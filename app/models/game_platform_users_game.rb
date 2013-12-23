class GamePlatformUsersGame < ActiveRecord::Base
  # Callbacks
  after_initialize :default_values

  # Associations
  belongs_to :game_platform_user
  belongs_to :game, class_name: "AllGame", foreign_key: "game_id"

  # Validations
  validates :playtime_count, presence: true, numericality: { greater_than_or_equal_to: 0, only_integer: true }
  validates :game_achievement_count, presence: true, numericality: { greater_than_or_equal_to: 0, only_integer: true }

  # Methods
  protected
  def default_values
    self.playtime_count ||= 0
    self.game_achievement_count ||= 0
  end
end
