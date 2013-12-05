class Album < ActiveRecord::Base
  attr_accessible :name, :description

  # Constants
  STATUS_NORMAL = 0
  STATUS_DELETED = 1
  TYPE_SCREENSHOT = 0
  TYPE_OTHER = 1

  # Callbacks
  after_initialize :default_values

  # Associations
  belongs_to :account

  # Validations
  validates :account, presence: true
  validates :name, presence: true, length: { maximum: 30 }
  validates :description, length: { maximum: 255 }, if: Proc.new{ |a| a.description }
  validates :status, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :album_type, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :photos_count, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  # Scope
  scope :screenshot_of_account, lambda { |account| where(album_type: self::TYPE_SCREENSHOT, account_id: account.id) }

  # Methods
  private
  def default_values
    self.status ||= self.class::STATUS_NORMAL if self.attribute_names.include?("status")
    self.album_type ||= self.class::TYPE_OTHER if self.attribute_names.include?("album_type")
    self.photos_count ||= 0 if self.attribute_names.include?("photos_count")
    self.description ||= "" if self.attribute_names.include?("description")
  end
end
