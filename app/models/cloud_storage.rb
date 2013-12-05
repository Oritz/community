class CloudStorage < ActiveRecord::Base
  attr_accessible :bucket_name, :key, :storage_type, :data, :private, :url

  # Constants
  STORAGE_TYPE_VEDIO = 0
  STORAGE_TYPE_IMAGE = 1
  IS_PRIVATE = 0
  IS_PUBLIC = 1

  # Callbacks
  after_initialize :default_values

  # Associations
  belongs_to :account

  # Validations
  validates :account, presence: true
  validates :bucket_name, presence: true, length: { maximum: 63 }
  validates :key, presence: true, length: { maximum: 63 }
  validates :storage_type, presence: true
  validates :private, presence: true

  # Methods
  def url
    if self.bucket_name && self.key
      "http://#{self.bucket_name}.u.qiniudn.com/#{self.key}"
    else
      ""
    end
  end

  def url=(url)
    return unless url
    begin
      url = url.split("http://")[1]
      tmps = url.split("/")
      key = tmps[1]
      bucket_name = tmps[0].split(".u.qiniudn.com")
      self.key = key
      self.bucket_name = bucket_name[0]
    rescue
      return
    end
  end

  private
  def default_values
    self.storage_type ||= self.class::STORAGE_TYPE_IMAGE
    self.private ||= self.class::IS_PUBLIC
  end
end
