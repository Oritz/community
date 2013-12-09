require 'sonkwo/exp'

class Talk < ActiveRecord::Base
  attr_accessible :content, :image_url, :cloud_storage_id
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
    t.add :image_url
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
  after_create { Sonkwo::Exp.increase("exp_post_talk", self.creator, self.created_at) }
  after_save :save_post_image

  # Associations
  has_one :post_image, foreign_key: "post_id"

  # Validations
  validates :content, presence: true, length: { maximum: 140 }

  # Scopes
  #scope :follower_talks, lambda { |account_id, limit_count| joins("INNER JOIN posts ON posts.id=talks.id INNER JOIN friendship ON posts.account_id=friendship.account_id").where("friendship.follower_id=?", account_id).order("posts.created_at DESC").limit(limit_count).includes(post: [:creator]) }

  # Methods
  def image_url
    return @image_url if @image_url
    return nil unless self.post_image
    self.post_image.url
  end

  def image_url=(url)
    @image_url = url.strip
  end

  def cloud_storage_id
    return @cloud_storage.id if @cloud_storage
    return nil unless self.post_image
    self.post_image.cloud_storage.id
  end

  def cloud_storage_id=(cloud_storage_id)
    begin
      @cloud_storage = CloudStorage.find(cloud_storage_id.to_i)
    rescue ActiveRecord::RecordNotFound
      return
    end
  end

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

  def save_post_image
    if @image_url && @image_url != ""
      if self.post_image == nil
        post_image = PostImage.new(url: @image_url)
        post_image.post_id = self.id
        post_image.save!
        self.post_image = post_image
      end
    elsif @cloud_storage
      if self.post_image == nil
        post_image = PostImage.new
        post_image.post_id = self.id
        post_image.cloud_storage = @cloud_storage
        post_image.save!
        self.post_image = post_image
      end
    end
  end
end
