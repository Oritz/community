class Photo < ActiveRecord::Base
  attr_accessible :description, :url

  # Constants
  STATUS_NORMAL = 0
  STATUS_DELETED = 1

  # Callbacks
  after_initialize :default_values
  before_save :save_cloud_storage

  # Associations
  belongs_to :account
  belongs_to :album
  belongs_to :cloud_storage

  # Validations
  validates :account, presence: true
  validates :album, presence: true
  #validates :cloud_storage, presence: true
  validates :description, length: { maximum: 255 }, if: Proc.new{ |a| a.description }
  validates :status, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validate :should_be_one_account

  # Methods
  def url
    return "" unless self.cloud_storage
    self.cloud_storage.url
  end

  def url=(url)
    self.cloud_storage.url = url if self.cloud_storage
  end

  private
  def default_values
    self.status ||= self.class::STATUS_NORMAL if self.attribute_names.include?("status")
    self.description ||= "" if self.attribute_names.include?("description")
    self.cloud_storage ||= CloudStorage.new(storage_type: CloudStorage::STORAGE_TYPE_IMAGE)
  end

  def save_cloud_storage
    self.cloud_storage = CloudStorage.new unless self.cloud_storage
    self.cloud_storage.account = self.account if self.account
    self.cloud_storage.save
  end

  def should_be_one_account
    if self.account && self.album
      return if self.account.id == self.album.account.id
      errors[:base] << I18n.t("album.photo.account_is_incorrect")
    end
  end
end
