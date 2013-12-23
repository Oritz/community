class GamePlatformUser < ActiveRecord::Base
  attr_accessible :game_platform_account, :latest_time

  # Constants
  STATUS_NORMAL = 0

  # Callbacks
  after_initialize :default_values

  # Associations
  belongs_to :game_platform
  has_many :game_platform_users_game
  has_many :games, through: :game_platform_users_game

  # Validations
  validates :game_platform, presence: true
  validates :game_platform_account, presence: true, length: { maximum: 255 }, uniqueness: { scope: :game_platform_id }
  validates :bind_count, presence: true, numericality: { greater_than_or_equal_to: 0, only_integer: true }
  validates :game_count, presence: true, numericality: { greater_than_or_equal_to: 0, only_integer: true }
  validates :status, presence: true, numericality: { greater_than_or_equal_to: 0, only_integer: true }
  validates_datetime :latest_time, if: Proc.new { |a| a.latest_time }

  # Methods
  protected
  def default_values
    self.status ||= self.class::STATUS_NORMAL
    self.bind_count ||= 0
    self.game_count ||= 0
  end
end
