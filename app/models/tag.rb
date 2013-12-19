class Tag < ActiveRecord::Base
  #attr_protected :id, :category, :created_at, :updated_at
  attr_accessible :name

  acts_as_api
  api_accessible :interest_info do |t|
    t.add :name
    t.add :id
  end

  # Constants
  CATEGORY_COMMON = 0
  CATEGORY_GROUP = 1
  CATEGORY_USER = 2

  # Callbacks
  after_initialize :default_values

  # Validations
  validates :name, presence: true, length: { maximum: 63 }

  # Associations
  has_many :groups_tags
  has_many :groups, through: :groups_tags
  has_many :accounts_tags
  has_many :accounts, through: :accounts_tags

  # Methods
  protected
  def default_values
    self.category ||= self.class::CATEGORY_COMMON
  end
end
