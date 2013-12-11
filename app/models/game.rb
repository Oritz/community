class Game < ActiveRecord::Base
  STATUS_NORMAL = 1
  TYPE_GAME = 1
  belongs_to :parent, class_name: "Game", foreign_key: "parent_id"
  has_many :game_files
  has_many :game_serial_numbers
end
