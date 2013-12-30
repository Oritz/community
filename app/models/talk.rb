require 'sonkwo/exp'

class Talk < ActiveRecord::Base
  attr_accessible :content, :image_url, :cloud_storage_id
  acts_as_polymorphic class_name: 'Post', name: 'detail', association: 'post'
  #acts_as_post

  # Callbacks
  before_create :add_talk_count
  after_create { Sonkwo::Exp.increase("exp_post_talk", self.post.creator, self.post.created_at) }
  after_save :save_post_image

  # Associations
  #has_one :post_image, foreign_key: "post_id"
  #has_one :post, as: :detail

  # Validations
  validates :content, presence: true, length: { maximum: 140 }

  # Scopes
  #scope :follower_talks, lambda { |account_id, limit_count| joins("INNER JOIN posts ON posts.id=talks.id INNER JOIN friendship ON posts.account_id=friendship.account_id").where("friendship.follower_id=?", account_id).order("posts.created_at DESC").limit(limit_count).includes(post: [:creator]) }

  # Methods
  def image_url
    return @image_url if @image_url
    return nil if self.post_images.empty?
    self.post_images[0].url
  end

  def image_url=(url)
    @image_url = url.strip
  end

  def cloud_storage_id
    return @cloud_storage.id if @cloud_storage
    return nil if self.post_images.empty?
    self.post_images[0].cloud_storage.id
  end

  def cloud_storage_id=(cloud_storage_id)
    begin
      @cloud_storage = CloudStorage.find(cloud_storage_id.to_i)
    rescue ActiveRecord::RecordNotFound
      return
    end
  end

  private
  def add_talk_count
    self.post.creator.talk_count += 1
    self.post.creator.save!
    if self.group
      self.group.talk_count += 1
      self.group.save!
    end
  end

  def save_post_image
    if @image_url && @image_url != ""
      if self.post_images.empty?
        post_image = PostImage.new(url: @image_url)
        post_image.post_id = self.id
        post_image.save!
        self.post_images << post_image
      end
    elsif @cloud_storage
      if self.post_images.empty?
        post_image = PostImage.new
        post_image.post_id = self.id
        post_image.cloud_storage = @cloud_storage
        post_image.save!
        self.post_images << post_image
      end
    end
  end
end
