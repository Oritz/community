class SteamFriend < ActiveRecord::Base
  attr_accessible :friend_since

  # Callbacks
  after_initialize :default_values
  before_create :check_friendship

  # Associations
  belongs_to :steam_user
  belongs_to :friend, class_name: 'SteamUser', foreign_key: 'friend_id'

  # Validations
  validates :steam_user, presence: true
  validates :friend, presence: true
  validates :steam_user_id, uniqueness: { scope: :friend_id }
  validates :friend_since, numericality: { only_integer: true }, presence: true

  # Methods
  private
  def default_values
    self.friend_since ||= 0
  end

  def check_friendship
    friendship = self.class.where("steam_user_id=? AND friend_id=?", self.friend.id, self.steam_user.id).first
    if friendship
      self.errors[:base] << "already exist"
      false
    end
  end
end
