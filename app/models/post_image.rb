class PostImage < ActiveRecord::Base
  attr_accessible :comment, :url

  # Callbacks
  before_save :save_cloud_storage

  # Associations
  belongs_to :post
  belongs_to :cloud_storage

  # Validations
  validates :post, presence: true
  validates :comment, length: { maximum: 30 }, if: Proc.new { |a| a.comment }
  validate :cloud_storage_or_url_at_least_one

  # Methods
  def url
    return @url if @url
    self.cloud_storage.url
  end

  def url=(url)
    @url = url.strip
  end

  private
  def save_cloud_storage
    if @url && @url != ""
      if self.cloud_storage == nil || self.cloud_storage.url != @url
        self.cloud_storage = CloudStorage.new(storage_type: CloudStorage::STORAGE_TYPE_IMAGE, url: url)
        self.cloud_storage.account = self.post.creator
        self.url = @url
      end
    end

    self.cloud_storage.save!
  end

  def cloud_storage_or_url_at_least_one
    if self.cloud_storage == nil && @url == nil
      errors[:base] << I18n.t("post_image.need_cloud_storage_or_url")
    end
  end
end
