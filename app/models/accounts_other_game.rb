class AccountsOtherGame < ActiveRecord::Base
  self.primary_keys = [:account_id, :game_id]

  # Callbacks
  after_initialize :default_values
  after_save :update_reputation
  before_destroy :destroy_reputation

  # Associations
  belongs_to :account
  belongs_to :game, class_name: "AllGame", foreign_key: "game_id"

  # Scope
  scope :chose_game, lambda { |game| where(game_id, game.id) }

  # Validations
  validates :account, presence: true
  validates :game, presence: true
  validates :playtime_forever, presence: true, numericality: { only_integer: true }, if: Proc.new { |a| a.playtime_forever }
  validates :playtime_2weeks, presence: true, numericality: { only_integer: true }, if: Proc.new { |a| a.playtime_2weeks }
  validates :achievements_count, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :account_id, uniqueness: { scope: [:game_id] }

  # Methods
  protected
  def default_values
    self.playtime_forever ||= 0
    self.playtime_2weeks ||= 0
    self.achievements_count ||= 0
  end

  def update_reputation
    item = UsersGamesReputationRanklist.where(game_id: self.game.id, user_id: self.account.id, user_type: "Account").first
    unless item
      item = UsersGamesReputationRanklist.new unless item
      item.game = self.game
      item.user = self.account
    end

    item.reputation = self.playtime_forever.to_i / 3600
    item.save!
  end

  def destroy_reputation
    item = UsersGamesReputationRanklist.where(game_id: self.game.id, user_id: self.account.id, user_type: "Account").first
    return false unless item.destroy
    true
  end
end
