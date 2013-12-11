require 'sonkwo/exp'

class Recommend < ActiveRecord::Base
  attr_accessible :content
  acts_as_notificable callbacks: ["after_create"], slot: "recommended", from: "creator", tos: ["original_author"]
  acts_as_polymorphic class_name: 'Post', name: 'detail', association: 'post'
  #acts_as_post find_options: {include: [original: [:creator]]},
  #  subpost: "original"
  #acts_as_behavior_provider author_key: "posts.account_id",
  #  timestamp: "posts.created_at",
  #  status: "posts.status",
  #  joins: "INNER JOIN posts ON posts.id=recommends.id",
  #  find_options: {include: [post: [:creator], original: [:creator]]}
  acts_as_api
  api_accessible :post_info do |t|
    t.add :creator
    t.add :id
    t.add :comment_count
    t.add :recommend_count
    t.add :like_count
    t.add :created_at
    t.add :updated_at
    t.add :content
    t.add :original_cast
  end

  # Callbacks
  after_create :add_recommend_count
  after_create { Sonkwo::Exp.increase("exp_recommend_post", self.creator, self.created_at) if self.original_author != self.creator }

  # Validations
  validates :content, presence: true, length: { maximum: 140 }

  # Associations
  belongs_to :original, class_name: 'Post', foreign_key: 'original_id'
  belongs_to :parent, class_name: 'Post', foreign_key: 'parent_id'
  belongs_to :original_author, class_name: 'Account', foreign_key: 'original_author_id'
  has_one :post, as: :detail

  # Scopes
  scope :recommend_posts_with_account, lambda { |post_id| joins("INNER JOIN posts ON posts.id=recommends.id").where("parent_id=? AND status=?", post_id, Post::STATUS_NORMAL).includes(post: [:creator]).order("posts.created_at DESC") }
  scope :account_recommended, lambda { |account_id| joins("INNER JOIN posts ON posts.id=recommends.id").where("original_author_id=? AND account_id<>? AND status=?", account_id, account_id, Post::STATUS_NORMAL).includes(post: [:creator]).order("posts.created_at DESC") }

  # Methods
  def original_cast
    self.original.cast
  end

  protected
  def add_recommend_count
    self.parent.recommend_count += 1
    self.parent.save!
    self.creator.recommend_count += 1
    self.creator.save!
  end
end
