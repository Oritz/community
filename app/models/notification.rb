class Notification < ActiveRecord::Base
  acts_as_api
  api_accessible :notify do |t|
    t.add :commented
    t.add :followed
    t.add :recommended
    t.add :liked
    t.add :mentioned
    t.add :private_message
  end

  # Validations
  validates :followed, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :commented, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :recommended, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :liked, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :mentioned, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :private_message, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  # Callbacks
  after_initialize :default_values

  # Associations
  belongs_to :account, class_name: 'Account', foreign_key: 'id', dependent: :destroy

  # Methods
  def reset(*args)
    attrs = args
    attrs = [:commented, :followed, :recommended, :liked, :mentioned, :private_message] if attrs == []
    attrs.each { |item| self.send("#{item}=", 0) if self.respond_to?(item) }
    self.save
  end

  protected
  def default_values
    self.followed ||= 0
    self.commented ||= 0
    self.recommended ||= 0
    self.liked ||= 0
    self.mentioned ||= 0
    self.private_message ||= 0
  end
end
