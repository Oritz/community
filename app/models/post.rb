class Post < ActiveRecord::Base
  # Plugins
  acts_as_postcastable
  acts_as_behavior_provider author_key: "account_id",
    timestamp: "created_at",
    status: "status",
    find_options: {include: [:creator]}
  acts_as_api
  api_accessible :post_info do |t|
    t.add :creator
    t.add :id
    t.add :post_type
    t.add :comment_count
    t.add :recommend_count
    t.add :like_count
    t.add :created_at
    t.add :updated_at
  end

  attr_accessible :comment
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
  TYPE_TALK = 0
  TYPE_SUBJECT = 1
  TYPE_RECOMMEND = 2

  # Callbacks
  after_initialize :default_values

  # Associations
  belongs_to :creator, class_name: 'Account', foreign_key: 'account_id'
  has_many :accounts_like_posts
  has_many :likers, through: :accounts_like_posts, source: :account
  has_many :comments, class_name: 'Comment'
  has_many :recommend_posts, class_name: 'Recommend', foreign_key: 'parent_id'
  belongs_to :group

  # Validations
  validates :post_type, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: self::TYPE_RECOMMEND }
  validates :privilege, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: self::PRIVILEGE_PRIVATE }
  validates :status, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: self::STATUS_DELETED }
  validates :comment_count, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :recommend_count, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :like_count, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :creator, presence: true
  validates :comment, length: { maximum: 140 }
  validate :group_should_be_added

  # Scopes
  scope :recommend_posts_with_account, lambda { |post_id| where("original_id=? AND status=?", post_id, Post::STATUS_NORMAL).includes(:creator).order("created_at DESC") }

  # Methods
  protected
  def default_values
    self.status ||= self.class::STATUS_NORMAL
    self.privilege ||= self.class::PRIVILEGE_PUBLIC
    self.comment_count ||= 0
    self.recommend_count ||= 0
    self.like_count ||= 0
  end

  def group_should_be_added
    if self.group && self.creator && !self.creator.groups.include?(self.group)
      errors.add(:group, I18n.t("models.post.error_group_not_added"))
    end
  end
end
