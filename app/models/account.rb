require "devise/encryptors/custom_sha1"
class Account < ActiveRecord::Base
  #include Humanizer
  #require_human_on :create

  control_access
  devise :database_authenticatable, :async, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :token_authenticatable, :confirmable,
         :lockable, :timeoutable, :encryptable

  acts_as_api
  api_accessible :comment_info do |t|
    t.add :id
    t.add :avatar
    t.add :nick_name
  end
  api_accessible :pm_info do |t|
    t.add :id
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

  UPDATE_TAG_FINISH = 3 # There're three steps

  attr_accessor :relationship
  attr_accessible :email, :password, :password_confirmation, :remember_me, :nick_name, :gender, :tos_agreement, :relation_id

  # Callbacks
  after_initialize :default_values
  #after_create :create_notification_item
  after_create :create_exp_strategy, :create_screenshot_album

  # Associations
  has_many :groups_accounts
  has_many :groups, through: :groups_accounts
  has_many :accounts_like_posts
  has_many :posts, inverse_of: :creator
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
  has_one :steam_user
  delegate :steam_id, to: :steam_user

  belongs_to :cloud_storage, class_name: "CloudStorage", foreign_key: "avatar_id"
  has_many :accounts_other_games
  has_many :other_games, through: :accounts_other_games, source: :game
  has_many :albums
  has_many :accounts_tags
  has_many :tags, through: :accounts_tags

  # Validations
  validates :exp, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :bonus, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :nick_name, presence: true, length: { in: 2..30 }, uniqueness: { case_sensitive: false, message: I18n.t("account.nick_name_is_used") }
  validates :email, presence: true, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, message: I18n.t("account.email_invalidate") }, length: { maximum: 128 }, uniqueness: { case_sensitive: false, message: I18n.t("account.email_is_used") }, allow_blank: false
  validates :password, presence: true, format: { with: /\A.*(?=.{8,})(?=.*[a-zA-Z0-9!\#$%&?"]).*\z/, message: I18n.t("account.email_invalidate") }, confirmation: true, on: :create
  validates :password_confirmation, presence: true, on: :create
  validates :tos_agreement, acceptance: { accept: 'true' }, on: :create

  # Scopes
  scope :post_likers, lambda { |post_id| where("post_id=?", post_id).joins("INNER JOIN accounts_like_posts ON accounts_like_posts.account_id=accounts.id").order("accounts_like_posts.created_at DESC") }
  scope :friends, lambda { |account| joins("INNER JOIN friendship ON follower_id=accounts.id").where("account_id=? AND is_mutual=#{Friendship::IS_MUTUAL}", account.id) }
  scope :not_in, lambda { |ids|  where("id NOT IN (?)", ids) }

  # Methods
  def pending_subject
    subject = Post.pending_of_account(self).first
    return subject if subject
    subject = Subject.new
    subject.status = Post::STATUS_PENDING
    subject.creator = self
    subject.save!
    subject.post
  end

  ###########################################
  # SocialActions
  ###########################################
  def comment(target, text, opts={})
    comment = Comment.new
    comment.creator = self
    comment.comment = text
    comment.post = target
    if opts[:original_id] && params[:original_id].to_i > 0
      original_comment = comment.find(params[:original_id])
      comment.original_author = original_comment.creator
    end

    result = comment.save
    [result, comment]
  end

  def recommend(target, text, opts={})
    post = Post.new
    post.creator = self
    post.parent = target
    if target.detail_type == "Talk" || target.detail_type == "Subject"
      post.original = target
    else
      post.original = target.original
    end
    post.recommendation = text
    result = post.save
    [result, post]
  end

  def posts_from_user(account)
    # TODO: add public/private here
    account.posts.all_public
  end

  def posts_from_users
    # TODO: add public/private here
    account_ids = [self.id]
    account_ids = account_ids | self.stars.select(:id).map(&:id)
    Post.where(account_id: account_ids).all_public
  end

  def posts_from_group(group)
    # TODO: add public/private here
    group.posts.all_public
  end

  def posts_from_groups
    group_ids = self.groups.map(&:id)
    Post.where(group_id: group_ids).all_public
  end

  ###########################################
  # GroupActions
  ###########################################

  def post_count
    self.talk_count + self.subject_count + self.recommend_count
  end

  def level
    Sonkwo::Exp.level(self.exp)
  end

  def games
    steam_user_games = []
    steam_user_games = self.steam_user.games if self.steam_user
    self.other_games + steam_user_games
  end

  def get_relation(account)
    return Friendship::IS_SELF if account.id == self.id
    friendship = Friendship.where("(account_id=? AND follower_id=?) OR (account_id=? AND follower_id=?)", self.id, account.id, account.id, self.id).first
    return Friendship::IRRESPECTIVE unless friendship
    return Friendship::MUTUAL if friendship.is_mutual == Friendship::IS_MUTUAL
    return Friendship::FOLLOWER if friendship.account_id == self.id
    Friendship::FOLLOWING
  end

  # Game playing histories
  def last_play_time(game_id)
    history = UserGamePlayHistory.where("account_id=? AND game_id=?", self.id, game_id).select("UNIX_TIMESTAMP(start_time) AS start_timestamp").order("start_time DESC").first
    history ? history.start_timestamp : -1
  end

  def play_time(game_id, options={})
    histories = UserGamePlayHistory.where("account_id=? AND game_id=?", self.id, game_id).select("SUM(UNIX_TIMESTAMP(exit_time)-UNIX_TIMESTAMP(start_time)) AS total_time")
    histories = histories.where("start_time>=?", options[:from]) if options[:from]
  end

  def add_tags(tag_ids)
    tags = Tag.where("id IN (?)", tag_ids)
    accounts_tags = []
    tags.each do |tag|
      accounts_tag = AccountsTag.new
      accounts_tag.account = self
      accounts_tag.tag = tag
      accounts_tags << accounts_tag
    end

    AccountsTag.import accounts_tags
  end

  protected
  def default_values
    self.gender ||= self.class::GENDER_BOY if self.attribute_names.include?("gender")
    self.follower_count ||= 0 if self.attribute_names.include?("follower_count")
    self.following_count ||= 0 if self.attribute_names.include?("following_count")
    self.talk_count ||= 0 if self.attribute_names.include?("talk_count")
    self.subject_count ||= 0 if self.attribute_names.include?("subject_count")
    self.recommend_count ||= 0 if self.attribute_names.include?("recommend_count")
    self.account_type ||= self.class::TYPE_NORMAL if self.attribute_names.include?("account_type")
    self.exp ||= 0 if self.attribute_names.include?("exp")
    self.bonus ||= 0 if self.attribute_names.include?("bonus")
    self.avatar ||= Settings.images.avatar.default if self.attribute_names.include?("avatar")
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

  def create_exp_strategy
    exp_strategies = ExpStrategy.all
    exp_strategies.each do |exp_strategy|
      item = AccountsExpStrategy.new
      item.account = self
      item.exp_strategy = exp_strategy
      item.period_count = 0
      item.save!
    end
  end

  def create_screenshot_album
    album = Album.new(name: Settings.albums.defaults.screenshot)
    album.album_type = Album::TYPE_SCREENSHOT
    album.account = self
    album.save!
  end
end
