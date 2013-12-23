class SteamFriend < ActiveRecord::Base
  attr_accessible :friend_since
  self.primary_keys = [:steam_user_id, :friend_id]

  # Callbacks
  after_initialize :default_values

  # Associations
  belongs_to :steam_user
  belongs_to :friend, class_name: 'SteamUser', foreign_key: 'friend_id'

  # Validations
  validates :steam_user, presence: true
  validates :friend, presence: true
  #validates :steam_user_id, uniqueness: { scope: :friend_id }
  validates :friend_since, numericality: { only_integer: true }, presence: true
  validate :friendship_cannot_be_duplicated

  # Methods
  private
  def default_values
    self.friend_since ||= 0
  end

  def friendship_cannot_be_duplicated
    friendship = self.class.where("(steam_user_id=? AND friend_id=?) OR (steam_user_id=? AND friend_id=?)", self.steam_user_id, self.friend_id, self.friend_id, self.steam_user_id).first
    if friendship
      errors[:base] << "friendship is duplicated"
    end
  end
end
