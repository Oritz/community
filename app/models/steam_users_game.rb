class SteamUsersGame < ActiveRecord::Base
  # Constants
  VISIBLE_STATS_ENABLE = 1
  VISIBLE_STATS_DISABLE = 0

  # Callbacks
  after_initialize :default_values

  # Associations
  belongs_to :steam_user
  belongs_to :game, class_name: "AllGame", foreign_key: "game_id"

  # Validations
  validates :steam_user, presence: true
  validates :game, presence: true
  validates :playtime_forever, numericality: { only_integer: true }, if: Proc.new { |a| a.playtime_forever }
  validates :playtime_2weeks, numericality: { only_integer: true }, if: Proc.new { |a| a.playtime_2weeks }
  validates :has_community_visible_stats, presence: true

  # Methods
  protected
  def default_values
    self.has_community_visible_stats ||= self.class::VISIBLE_STATS_ENABLE
  end
end
