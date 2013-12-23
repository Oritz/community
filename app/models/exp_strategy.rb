class ExpStrategy < ActiveRecord::Base
  attr_accessible :name, :app_name, :period_type, :time_limit, :data, :value

  # Constants
  STATUS_NORMAL = 0
  STATUS_CLOSED = 1
  TYPE_ONCE = 0
  TYPE_DAY = 1
  TYPE_UNLIMITED = 2

  # Callbacks
  after_create :create_accounts_exp_strategy

  # Associations
  has_many :accounts_exp_strategies, dependent: :destroy
  has_many :accounts, through: :accounts_exp_strategies

  # Validations
  validates :name, presence: true, length: { maximum: 255 }
  validates :app_name, presence: true, length: { maximum: 255 }
  validates :period_type, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :status, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :time_limit, numericality: { only_integer: true }
  validates :value, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :bonus, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  # Methods
  private
  def create_accounts_exp_strategy
    accounts = Account.all
    accounts.each do |account|
      item = AccountsExpStrategy.new
      item.account = account
      item.exp_strategy = self
      item.period_count = 0
      item.save!
    end
  end
end
