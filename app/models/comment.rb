class Comment < ActiveRecord::Base
  #acts_as_notificable callbacks: ["after_create"], slot: "commented", from: "creator", tos: ["original_author", "post_author"]
  attr_accessible :comment
  # Constants
  # Comment Status
  STATUS_PENDING = 0
  STATUS_NORMAL = 1
  STATUS_DELETED = 2

  # Validations
  validates :comment, presence: true, length: { maximum: 140 }
  validates :status, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: self::STATUS_DELETED }
  validates :creator, presence: true
  validates :post, presence: true
  validates :post_author, presence: true

  # Callbacks
  after_initialize :default_values

  # Associations
  belongs_to :creator, class_name: 'Account', foreign_key: 'author_id'
  belongs_to :post
  belongs_to :post_author, class_name: 'Account', foreign_key: 'post_author_id'
  belongs_to :original, class_name: 'Comment', foreign_key: 'original_id'
  belongs_to :original_author, class_name: 'Account', foreign_key: 'original_author_id'

  # Scopes
  scope :comments_with_account, lambda { |post_id| where("post_id=? AND status=?", post_id, Comment::STATUS_NORMAL).includes(:creator, :original_author).order("created_at DESC") }
  scope :account_in, lambda { |account_id| where("(original_author_id=? OR post_author_id=?) AND author_id<>? AND status=?", account_id, account_id, account_id, Comment::STATUS_NORMAL).includes(:creator, :post, :original).order("created_at DESC") }
  scope :account_out, lambda { |account_id| where("author_id=? AND status=?", account_id, Comment::STATUS_NORMAL).includes(:creator, :post, :original).order("created_at DESC") }

  # Methods
  protected
  def add_comment_count
    self.post.comment_count += 1
    self.post.save!
  end

  def default_values
    self.status ||= self.class::STATUS_NORMAL
  end
end
