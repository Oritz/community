class SteamGame < ActiveRecord::Base
  attr_accessible :appid

  # Associations
  has_one :game, class_name: 'AllGame', as: :subable

  # Validations
  validates :appid, presence: true, numericality: { only_integer: true }
end
