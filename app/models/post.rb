class Post < ActiveRecord::Base
  # Plugins
  acts_as_behavior_provider author_key: "account_id",
    timestamp: "created_at",
    status: "status",
    find_options: {include: [:detail, :creator]}
  #acts_as_polymorphic name: "detail"

  attr_accessible :recommendation
  #attr_protected :post_type, :privilege, :status, :comment_count, :recommend_count, :like_count, :created_at, :updated_at
  # Constants
  # Post Status
  STATUS_PENDING = 0
  STATUS_NORMAL = 1
  STATUS_DELETED = 2

  # Post Privilege
  PRIVILEGE_PUBLIC = 0
  PRIVILEGE_PRIVATE = 1

  # Post Type
  #TYPE_TALK = 0
  #TYPE_SUBJECT = 1
  #TYPE_RECOMMEND = 2

  # Callbacks
  after_initialize :default_values
  before_create :add_post_count
  after_create do
    Sonkwo::Exp.increase("exp_recommend_post", self.creator, self.created_at) if self.original && self.original_creator != self.creator
  end

  # Associations
  belongs_to :creator, class_name: 'Account', foreign_key: 'account_id', inverse_of: :posts
  delegate :nick_name, :avatar, :level, to: :creator, prefix: true
  has_many :accounts_like_posts
  has_many :likers, through: :accounts_like_posts, source: :account
  has_many :comments, class_name: 'Comment'
  #has_many :recommend_posts, class_name: 'Recommend', foreign_key: 'parent_id'
  belongs_to :group, inverse_of: :posts
  has_many :post_images
  belongs_to :detail, polymorphic: true
  delegate :content, :title, to: :detail

  has_one :image, class_name: 'PostImage', foreign_key: 'post_id'
  delegate :url, to: :image, prefix: true

  has_one :tipoff, as: :detail

  # Recommend Association
  belongs_to :original, class_name: 'Post', foreign_key: 'original_id'
  delegate :content, :title, :creator, :image_url, to: :original, prefix: true
  belongs_to :parent, class_name: 'Post', foreign_key: 'parent_id'

  # Validations
  validates :privilege, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: self::PRIVILEGE_PRIVATE }
  validates :status, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: self::STATUS_DELETED }
  validates :comment_count, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :recommend_count, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :like_count, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :creator, presence: true
  validates :recommendation, length: { maximum: 140, message: I18n.t("post.recommendation_is_too_long") }, allow_blank: true
  #validates :detail_type, presence: true
  #validates :detail_id, presence: true
  validate :group_should_be_added
  validate :only_one_pending_post

  # Scopes
  scope :recommend_posts_with_account, lambda { |post_id| where("original_id=? AND status=?", post_id, Post::STATUS_NORMAL).includes(:creator).order("created_at DESC") }
  scope :pending_of_account, lambda { |account| where("account_id=? AND status=?", account.id, Post::STATUS_PENDING) }

  scope :all_public, where(status: self::STATUS_NORMAL)
  scope :includes_for_a_stream, includes([:image, :detail, :creator, original: [:detail, :image]])

  # Methods
  class << self
    def for_a_stream(min_id, order, user)
      # TODO: add visible(public/private) here
      min_id > 0 ? where("posts.id < ?", min_id).order(order).includes_for_a_stream : order(order).includes_for_a_stream
    end
  end

  protected
  def default_values
    self.status ||= self.class::STATUS_NORMAL
    self.privilege ||= self.class::PRIVILEGE_PUBLIC
    self.comment_count ||= 0
    self.recommend_count ||= 0
    self.like_count ||= 0
  end

  def add_post_count
    if self.parent && self.detail_type != "Talk" && self.detail_type != "Subject"
      self.creator.recommend_count += 1
      self.parent.recommend_count += 1
      self.parent.save!
      if self.original.id != self.parent.id
        self.original.recommend_count += 1
        self.original.save!
      end
      self.creator.save!
    end
  end

  def group_should_be_added
    if self.group && self.creator && !self.group.accounts.include?(self.creator)
      errors.add(:group, I18n.t("models.post.error_group_not_added"))
    end
  end

  def only_one_pending_post
    return unless self.creator
    pending_item = self.class.where(account_id: self.creator.id, status: self.class::STATUS_PENDING).first
    if pending_item && self.status == self.class::STATUS_PENDING && self.id != pending_item.id
      errors[:base] << I18n.t("post.more_than_one_pending_post")
    end
  end
end
