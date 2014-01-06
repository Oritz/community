class CloudStorage < ActiveRecord::Base
  class UrlError < StandardError; end

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
  class << self
    def settings(account, bucket_name=Settings.cloud_storage.default_bucket)
      now = Time.now.to_i
      sonkwo_token = Digest::MD5.hexdigest("#{account.id},#{now},#{Settings.cloud_storage.sonkwo_key}")
      upload_token = Qiniu::RS.generate_upload_token(
                                                     scope: bucket_name,
                                                     expires_in: Settings.cloud_storage.token_expire,
                                                     callback_url: Settings.cloud_storage.callback_url,
                                                     callback_body: Settings.cloud_storage.callback_body,
                                                     callback_body_tpye: Settings.cloud_storage.callback_body_type,
                                                     customer: account.id.to_s,
                                                     escape: Settings.cloud_storage.escape,
                                                     async_options: Settings.cloud_storage.async_options,
                                                     return_body: Settings.cloud_storage.return_body)

      {now: now, upload_token: upload_token, sonkwo_token: sonkwo_token}
    end
  end

  def url
    if self.bucket_name && self.key
      "http://#{self.bucket_name}.qiniudn.com/#{self.key}"
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
      bucket_name = tmps[0].split(".qiniudn.com")
      self.key = key
      self.bucket_name = bucket_name[0]
    rescue
      raise UrlError, I18n.t("cloud_storage.url_invalid")
    end
  end

  private
  def default_values
    self.storage_type ||= self.class::STORAGE_TYPE_IMAGE
    self.private ||= self.class::IS_PUBLIC
  end
end
