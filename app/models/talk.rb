class Talk < ActiveRecord::Base
  acts_as_post
  #acts_as_behavior_provider author_key: "posts.account_id",
  #  timestamp: "posts.created_at",
  #  status: "posts.status",
  #  joins: "INNER JOIN posts ON posts.id=talks.id",
  #  find_options: {include: [post: [:creator]]}
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
    t.add :content
  end

  # Callbacks
  after_initialize :default_values
  before_create :add_talk_count

  # Validations
  validates :content, presence: true, length: { maximum: 140 }

  # Scopes
  #scope :follower_talks, lambda { |account_id, limit_count| joins("INNER JOIN posts ON posts.id=talks.id INNER JOIN friendship ON posts.account_id=friendship.account_id").where("friendship.follower_id=?", account_id).order("posts.created_at DESC").limit(limit_count).includes(post: [:creator]) }

  # Methods
  private
  def default_values
    unless self.id
      self.post = Post.new
      self.post_type = Post::TYPE_TALK
    end
  end

  def add_talk_count
    self.creator.talk_count += 1
    self.creator.save!
  end
end
