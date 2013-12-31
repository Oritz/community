class SteamUsersGame < ActiveRecord::Base
  self.primary_keys = [:steam_user_id, :game_id]
  # Constants
  VISIBLE_STATS_ENABLE = 1
  VISIBLE_STATS_DISABLE = 0

  # Callbacks
  after_initialize :default_values
  after_save :update_reputation
  before_destroy :destroy_reputation

  # Associations
  belongs_to :steam_user
  belongs_to :game, class_name: "AllGame", foreign_key: "game_id"

  # Scope
  scope :choose_game, lambda { |game| where(game_id: game.id) }

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
    item = UsersGamesReputationRanklist.where(game_id: self.game.id, user_id: self.steam_user.id, user_type: "SteamUser").first
    unless item
      item = UsersGamesReputationRanklist.new
      item.game = self.game
      item.user = self.steam_user
    end

    item.reputation = (self.playtime_forever.to_i / 3600) + self.achievements_count.to_i * 2
    item.save!
  end

  def destroy_reputation
    item = UsersGamesReputationRanklist.where(game_id: self.game.id, user_id: self.steam_user.id, user_type: "SteamUser").first
    return false unless item.destroy
    true
  end
end
