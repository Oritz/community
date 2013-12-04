class Group < ActiveRecord::Base
  acts_as_api
  api_accessible :post_info do |t|
    t.add :id
    t.add :name
  end

  #attr_protected :member_count, :creator_id, :group_type, :status, :created_at, :updated_at
  attr_accessible :name, :description, :logo
  #mount_uploader :logo, GroupUploader
  # Constants
  TYPE = {'OFFICAL' => 0, 'FOLK' => 1}
  STATUS = {'NORMAL' => 0}

  # Callbacks
  after_initialize :default_values
  after_create :created

  # Validations
  validates :name, presence: true, length: { maximum: 31 }
  validates :description, presence: true, length: { maximum: 255 }
  validates :member_count, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :group_type, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than: self::TYPE.count }
  validates :status, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than: self::STATUS.count }
  validates :creator, presence: true
  validates :logo, presence: true, length: { maximum: 255 }

  # Associations
  belongs_to :creator, class_name: 'Account', foreign_key: 'creator_id'
  has_many :groups_accounts
  has_many :accounts, through: :groups_accounts,
    after_add: :account_added,
    after_remove: :account_removed
  has_many :subjects
  has_many :groups_tags
  has_many :tags, through: :groups_tags

  # Scopes
  scope :sort_by_hot, ->(count) { order("#{table_name}.member_count DESC").limit(count) }

  # Methods
  def joined?(account)
    self.accounts.include?(account)
  end

  def newcomers(count)
    return [] if count <= 0

    self.accounts.order("groups_accounts.created_at DESC").limit(count)
  end

  def add_tags(tags=[])
    tags = Tag.where("id IN (?)", tags)
    tags.each { |tag| self.tags << tag if !self.tags.include?(tag) }
  end

  private
  def account_added(account)
    self.member_count += 1
    self.save!
  end

  def account_removed(account)
    self.member_count -= 1
    self.member_count = 0 if self.member_count < 0
    self.save!
  end

  def created
    raise ActiveRecord::Rollback unless self.accounts << self.creator
  end

  def default_values
    self.member_count ||= 0
    self.status ||= self.class::STATUS['NORMAL']
    self.group_type ||= self.class::TYPE['OFFICAL']
    self.logo ||= Settings.images.group.default
  end
end
