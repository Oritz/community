class SteamUsersGameAchievement < ActiveRecord::Base
  # Associations
  belongs_to :steam_user
  belongs_to :game_achievement
end
