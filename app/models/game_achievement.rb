class GameAchievement < ActiveRecord::Base
  # attr_accessible :title, :body
  attr_accessible :name, :description, :lock_url, :unlock_url, :game_id, :subable_type, :subable_attributes

  # Constants
  STATUS_NORMAL = 0

  # Associations
  belongs_to :game, class_name: 'AllGame', foreign_key: 'game_id', dependent: :destroy
  belongs_to :subable, polymorphic: true
  accepts_nested_attributes_for :subable
  # Callbacks
  after_initialize :default_values

  # Validations
  validates :name, presence: true, length: { maximum: 255 }
  validates :description, presence: true
  validates :lock_url, presence: true, length: { maximum: 255 }
  validates :unlock_url, presence: true, length: { maximum: 255 }
  validates :game, presence: true
  validates :subable, presence: true
  #validates :subable_id, uniqueness: { scope: :subable_type }

  # Scopes
  scope :choose_game, lambda {|game| where(game_id: game.id) }
  scope :all_normal, where(status: self::STATUS_NORMAL)
  scope :with_steam_user, lambda {|steam_user| joins("LEFT JOIN steam_users_game_achievements ON game_achievements.id=steam_users_game_achievements.game_achievement_id AND steam_users_game_achievements.steam_user_id=#{steam_user.id}").select("steam_user_id, steam_users_game_achievements.created_at") }

  # Methods
  def get_subable
    case self.game.subable_type
    when 'SteamGame'
      sub_achieve = SteamGameAchievement.new
    when 'LiveGame'
     # sub_achieve = LiveGameAchievement.new
    end
    return sub_achieve
  end
  protected
  def default_values
    self.status ||= self.class::STATUS_NORMAL if self.attribute_names.include?("status")
  end

  def subable_attributes=(attributes)
    this_subable = self.subable_type.constantize.find_or_initialize_by_id(self.subable_id)
    this_subable.attributes = attributes
    self.subable = this_subable
  end
end
