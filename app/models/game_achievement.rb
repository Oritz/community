class GameAchievement < ActiveRecord::Base
  # attr_accessible :title, :body
  attr_accessible :name, :description, :lock_url, :unlock_url

  # Constants
  STATUS_NORMAL = 0

  # Associations
  belongs_to :game, class_name: 'AllGame', foreign_key: 'game_id', dependent: :destroy
  belongs_to :subable, polymorphic: true

  # Callbacks
  after_initialize :default_values

  # Validations
  validates :name, presence: true, length: { maximum: 255 }
  validates :description, presence: true
  validates :lock_url, presence: true, length: { maximum: 255 }
  validates :unlock_url, presence: true, length: { maximum: 255 }
  validates :game, presence: true
  validates :subable, presence: true
  validates :subable_id, uniqueness: { scope: :subable_type }

  # Scopes

  # Methods
  protected
  def default_values
    self.status ||= self.class::STATUS_NORMAL
  end
end
