class AllGame < ActiveRecord::Base
  # attr_accessible :title, :body
  attr_accessible :name, :image, :subable_type, :subable_attributes
  acts_as_api
  api_accessible :game_basic_info do |t|
    t.add :id
    t.add :image
    t.add :name
  end

  # Constants
  STATUS_NORMAL = 0
  TYPE_OFFICAL = 0
  TYPE_UNOFFICAL = 1


  # Callbacks
  after_initialize :default_values

  # Associations
  has_many :game_achievements, foreign_key: 'game_id', class_name: 'GameAchievement', dependent: :destroy
  belongs_to :subable, polymorphic: true
  has_many :ranklists, class_name: "UsersGamesReputationRanklist", foreign_key: "game_id", dependent: :destroy
  accepts_nested_attributes_for :subable

  # Validations
  validates :name, presence: true, length: { maximum: 255 }
  validates :image, presence: true, length: { maximum: 255 }
  validates :status, presence: true
  validates :subable_id, uniqueness: { scope: :subable_type }, if: Proc.new { |a| a.subable_id }

  # Scopes
  scope :belong_to_account, lambda { |account| joins("INNER JOIN users_games_reputation_ranklists ON game_id=all_games.id").where("(user_id=? AND user_type=?) OR (user_id=? AND user_type=?)", account.id, account.class.to_s, account.steam_user, account.steam_user.class.to_s).group(:id) }
  scope :sonkwo_games, ->{where('subable_id is NULL')}
  # Methods
  def self.have_type?(type)
    %w(SteamGame LiveGame).include?(type)
  end

  protected
  def default_values
    self.status ||= self.class::STATUS_NORMAL
    self.image ||= Settings.images.game.default
  end

  def subable_attributes=(attributes)
    this_subable = self.subable_type.constantize.find_or_initialize_by_id(self.subable_id)
    this_subable.attributes = attributes
    self.subable = this_subable
  end
end
