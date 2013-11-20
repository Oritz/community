class AllGame < ActiveRecord::Base
  # attr_accessible :title, :body
  attr_accessible :name

  # Constants
  STATUS_NORMAL = 0
  TYPE_OFFICAL = 0
  TYPE_UNOFFICAL = 1

  # Callbacks
  after_initialize :default_values

  # Associations
  has_many :game_achievements, foreign_key: 'game_id', class_name: 'GameAchievement', dependent: :destroy

  # Validations
  validates :name, presence: true, length: { maximum: 255 }
  validates :game_type, presence: true
  validates :status, presence: true

  # Methods
  protected
  def default_values
    self.game_type ||= self.class::TYPE_OFFICAL
    self.status ||= self.class::STATUS_NORMAL
  end
end
