class SteamUsersGame < ActiveRecord::Base
  self.primary_keys = [:steam_user_id, :game_id]
  # Constants
  VISIBLE_STATS_ENABLE = 1
  VISIBLE_STATS_DISABLE = 0

  # Callbacks
  after_initialize :default_values
  after_save :update_reputation

  # Associations
  belongs_to :steam_user
  belongs_to :game, class_name: "AllGame", foreign_key: "game_id"

  # Validations
  validates :steam_user, presence: true
  validates :game, presence: true
  validates :playtime_forever, numericality: { only_integer: true }, if: Proc.new { |a| a.playtime_forever }
  validates :playtime_2weeks, numericality: { only_integer: true }, if: Proc.new { |a| a.playtime_2weeks }
  validates :has_community_visible_stats, presence: true
  validates :achievements_count, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  # Methods
  protected
  def default_values
    self.has_community_visible_stats ||= self.class::VISIBLE_STATS_ENABLE
    self.achievements_count ||= 0
  end

  def update_reputation
    item = UsersGamesReputationRanklist.where(game_id: self.game.id, user_id: self.account.id, user_type: "Account").first
    unless item
      item = UsersGamesReputationRanklist.new unless item
      item.game = self.game
      item.user = self.account
    end

    item.reputation = self.playtime_forever / 3600 + self.achievements_count * 2
    item.save!
  end
end