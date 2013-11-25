class SteamGameAchievement < ActiveRecord::Base
  attr_accessible :api_name, :percent

  # Associations
  has_one :game_achievement, as: :subable
  belongs_to :steam_game

  # Validates
  validates :steam_game, presence: true
  validates :api_name, presence: true, length: {maximum: 255}, uniqueness: { scope: :steam_game_id }
  validates :percent, numericality: { greater_than_or_equal_to: 0.0, less_than_or_equal_to: 100.0 }, if: Proc.new { |a| a.percent }
end
