require 'validators/steamid_validator'

class SteamUser < ActiveRecord::Base
  attr_accessible :steamid, :personaname, :profile_url, :avatar, :communityvisibilitystate, :profilestate, :lastlogoff, :commentpermission, :realname, :primaryclanid, :timecreated, :loccountrycode, :locstatecode, :loccityid

  # Associations
  belongs_to :account, select: "avatar, nick_name"
  delegate :avatar, :nick_name, to: :account, prefix: true

  has_many :steam_users_game_achievements
  has_many :game_achievements, through: :steam_users_game_achievements
  has_many :steam_users_games
  has_many :games, through: :steam_users_games

  # Scope

  # Validations
  validates :steamid, presence: true, length: { maximum: 63 }, steamid: true
  validates :personaname, length: { maximum: 255 }, uniqueness: true, if: Proc.new { |a| a.personaname }
  validates :profile_url, length: { maximum: 255 }, if: Proc.new { |a| a.profile_url }
  validates :avatar, length: { maximum: 255 }, if: Proc.new { |a| a.avatar }
  validates :communityvisibilitystate, numericality: { only_integer: true }, if: Proc.new { |a| a.communityvisibilitystate }
  validates :profilestate, numericality: { only_integer: true }, if: Proc.new { |a| a.profilestate }
  validates :commentpermission, numericality: { only_integer: true }, if: Proc.new { |a| a.commentpermission }
  validates :realname, length: { maximum: 255 }, if: Proc.new { |a| a.realname }
  validates :primaryclanid, length: { maximum: 255 }, if: Proc.new { |a| a.primaryclanid }
  validates :loccountrycode, length: { maximum: 15 }, if: Proc.new { |a| a.loccountrycode }
  validates :locstatecode, length: { maximum: 15 }, if: Proc.new { |a| a.locstatecode }
  validates :loccityid, numericality: { only_integer: true }, if: Proc.new { |a| a.loccityid }
  validates :lastlogoff, numericality: { only_integer: true, lager_than_or_equal_to: 0 }, if: Proc.new { |a| a.lastlogoff }
  validates :timecreated, numericality: { only_integer: true, lager_than_or_equal_to: 0 }, if: Proc.new { |a| a.timecreated }
  validates :account_id, uniqueness: true, if: Proc.new { |a| a.account_id }
end
