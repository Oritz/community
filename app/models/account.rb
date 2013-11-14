require "devise/encryptors/custom_sha1"
class Account < ActiveRecord::Base
  control_access
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :token_authenticatable, :confirmable,
         :lockable, :timeoutable, :encryptable

  acts_as_api
  api_accessible :post_info do |t|
    t.add :id
    t.add :avatar
    t.add :nick_name
  end

  EMAIL_NOT_VERIFY = 0
  EMAIL_VERIFIED = 1
  INVITED = 1
  PAID_USER = 0
  UNPAID_USER = 1
  GENDER_BOY = 0
  GENDER_GIRL = 1
  TYPE_NORMAL = 0

  attr_accessible :email, :password, :password_confirmation, :remember_me, :nick_name, :gender
  #attr_accessor :crop_x, :crop_y, :crop_w, :crop_h, :avatar_upload_width, :avatar_upload_height

  #mount_uploader :avatar, AvatarUploader

  # Callbacks
  after_initialize :default_values
  #after_create :create_notification_item

  # Associations
  has_many :groups_accounts
  has_many :groups, through: :groups_accounts
  has_many :accounts_like_posts
  has_many :posts
  has_many :like_posts, through: :accounts_like_posts, source: :post,
    after_add: :post_liked,
    after_remove: :post_unliked
  has_many :friendship
  has_and_belongs_to_many :fans,
    class_name: "Account",
    join_table: "friendship",
    foreign_key: 'account_id',
    association_foreign_key: 'follower_id',
    before_add: :forbid_callback
  has_and_belongs_to_many :stars,
    class_name: "Account",
    join_table: "friendship",
    foreign_key: 'follower_id',
    association_foreign_key: 'account_id',
    before_add: :forbid_callback
  has_one :notification, foreign_key: 'id', dependent: :destroy
  has_many :client_errors, dependent: :destroy

  # Scopes
  scope :post_likers, lambda { |post_id| where("post_id=?", post_id).joins("INNER JOIN accounts_like_posts ON accounts_like_posts.account_id=accounts.id").order("accounts_like_posts.created_at DESC") }

  # Methods
  def people_relation_with_visitor(options={})
    options.assert_valid_keys(:visitor, :type, :select, :page, :per_page)
    options[:visitor] ||= self
    options[:type] ||= Friendship::FOLLOWER
    options[:select] ||= "accounts.*"

    accounts = self
    if options[:type] == Friendship::FOLLOWER
      accounts = accounts.fans
    else
      accounts = accounts.stars
    end

    accounts = accounts.order("friendship.created_at DESC").select(options[:select])

    if self == options[:visitor]
      accounts = accounts.select("is_mutual")
      accounts = accounts.paginate(page: options[:page], per_page: options[:per_page])
      accounts.each do |account|
        class << account
          attr_accessor :relation
        end
        if account.is_mutual == Friendship::IS_MUTUAL
          account.relation = Friendship::MUTUAL
        elsif options[:type] == Friendship::FOLLOWER
          account.relation = Friendship::FOLLOWER
        else
          account.relation = Friendship::FOLLOWING
        end
      end

      return accounts
    end

    accounts = accounts.paginate(page: options[:page], per_page: options[:per_page])
    ids = accounts.collect { |a| a.id }

    follower_relations = Friendship.where("account_id=#{options[:visitor].id} AND follower_id IN (?)", ids)
    following_relations = Friendship.where("account_id IN (?) AND follower_id=#{options[:visitor].id}", ids)
    follower_ids = follower_relations.collect { |r| r.follower_id }
    following_ids = following_relations.collect { |r| r.account_id }

    accounts.each do |account|
      class << account
        attr_accessor :relation
      end
      if account.id == options[:visitor].id
        account.relation = Friendship::IS_SELF
      elsif following_ids.include?(account.id) && follower_ids.include?(account.id)
        account.relation = Friendship::MUTUAL
      elsif follower_ids.include?(account.id)
        account.relation = Friendship::FOLLOWER
      elsif following_ids.include?(account.id)
        account.relation = Friendship::FOLLOWING
      else
        account.relation = nil
      end
    end
    return accounts
  end

  # Crop
  #def cropping?
    #!crop_x.blank? && !crop_y.blank? && !crop_w.blank? && !crop_h.blank?
  #end

  # Game playing histories
  def last_play_time(game_id)
    history = UserGamePlayHistory.where("account_id=? AND game_id=?", self.id, game_id).select("UNIX_TIMESTAMP(start_time) AS start_timestamp").order("start_time DESC").first
    history ? history.start_timestamp : -1
  end

  def play_time(game_id, options={})
    histories = UserGamePlayHistory.where("account_id=? AND game_id=?", self.id, game_id).select("SUM(UNIX_TIMESTAMP(exit_time)-UNIX_TIMESTAMP(start_time)) AS total_time")
    histories = histories.where("start_time>=?", options[:from]) if options[:from]
  end

  protected
  def default_values
    self.gender ||= self.class::GENDER_BOY
    self.follower_count ||= 0
    self.following_count ||= 0
    self.talk_count ||= 0
    self.subject_count ||= 0
    self.recommend_count ||= 0
    self.account_type ||= self.class::TYPE_NORMAL
  end

  def post_liked(post)
    post.like_count += 1
    post.save!
  end

  def post_unliked(post)
    post.like_count -= 1
    post.like_count = 0 if post.like_count < 0
    post.save!
  end

  #def forbid_callback(account)
  #  raise "The actions is forbidden."
  #end

  def create_notification_item
    notification = Notification.new
    notification.account = self
    notification.save!
  end
end
