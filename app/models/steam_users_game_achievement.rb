class SteamUsersGameAchievement < ActiveRecord::Base
  # Callbacks
  after_create :add_achievements_count

  # Associations
  belongs_to :steam_user
  belongs_to :game_achievement

  # Methods
  private
  def add_achievements_count
    steam_users_game = SteamUsersGame.where(steam_user_id: self.steam_user.id, game_id: self.game_achievement.game.id).first
    return unless steam_users_game
    steam_users_game.achievements_count += 1
    steam_users_game.save!
  end
end
