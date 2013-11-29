class AccountsExpStrategy < ActiveRecord::Base
  self.primary_keys = [:account_id, :exp_strategy_id]

  # Associations
  belongs_to :account
  belongs_to :exp_strategy

  # Validations
  validates :period_count, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :account, presence: true
  validates :exp_strategy, presence: true
  validates :account_id, uniqueness: { scope: [:exp_strategy_id] }
end
