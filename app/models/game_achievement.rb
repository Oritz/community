class GameAchievement < ActiveRecord::Base
  # attr_accessible :title, :body
  attr_accessible :name, :description, :api_name, :lock_url, :unlock_url, :percentage

  # Constants
  STATUS_NORMAL = 0

  # Associations
  belongs_to :game, class_name: 'AllGame', foreign_key: 'game_id', dependent: :destroy

  # Callbacks
  after_initialize :default_values

  # Validations
  validates :name, presence: true, length: { maximum: 255 }
  validates :description, presence: true
  validates :api_name, presence: true, length: { maximum: 255 }, uniqueness: { scope: :game_id }
  validates :lock_url, presence: true, length: { maximum: 255 }
  validates :unlock_url, presence: true, length: { maximum: 255 }
  validates :percentage, numericality: { greater_than_or_equal_to: 0.0, less_than_or_equal_to: 100.0 }, if: Proc.new { |a| a.percentage }
  validates :game, presence: true

  # Scopes

  # Methods
  protected
  def default_values
    self.status ||= self.class::STATUS_NORMAL
  end
end
