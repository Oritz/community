class UsersGamesReputationRanklist < ActiveRecord::Base
  # attr_accessible :title, :body
  # Constants
  RANK_UNKNOWN = 0
  RANK_ELITE = 1
  RANK_HARDCORE = 2
  RANK_DEDICATED = 3
  RANK_EXPERIENCED = 4
  RANK_AMATEUR = 5
  RANK_NEWBIE = 6

  # Callbacks
  after_initialize :default_values

  # Assocations
  belongs_to :game, class_name: "AllGame", foreign_key: "game_id"
  belongs_to :user, polymorphic: true

  # Scopes
  scope :choose_user, lambda { |user| where(user_id: user.id, user_type: user.class.to_s) }

  # Validations
  validates :game, presence: true
  validates :user, presence: true
  validates :reputation, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :delta_reputation, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :rank, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  # Methods
  def rank_to_string
    tmp = self.rank.to_i
    reputation = Settings.reputation
    reputation.values[tmp]["name"]
  end

  private
  def default_values
    self.reputation ||= 0
    self.delta_reputation ||= 0
    self.rank ||= self.class::RANK_UNKNOWN
  end
end
