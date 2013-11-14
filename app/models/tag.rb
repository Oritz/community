class Tag < ActiveRecord::Base
  attr_protected :id, :category, :created_at, :updated_at
  attr_accessible :name

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

  protected
  def default_values
    self.category ||= self.class::CATEGORY_COMMON
  end
end
