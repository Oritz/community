class GamePlatform < ActiveRecord::Base
  attr_accessible :name, :api_key

  # Constants
  TYPE_SONKWO = 0
  TYPE_STEAM = 1

  # Callbacks
  after_initialize :default_values

  # Associations
  has_many :game_platform_users

  # Validations
  validates :name, presence: true, length: { maximum: 31 }, uniqueness: true
  validates :api_key, length: { maximum: 255 }, if: Proc.new { |a| a.api_key }
  validates :platform_type, presence: true, numericality: { only_integer: true }

  # Methods
  protected
  def default_values
    self.platform_type ||= self.class::TYPE_SONKWO
  end
end
