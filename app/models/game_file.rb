class GameFile < ActiveRecord::Base
  # attr_accessible :title, :body
  KEY_LEN = 16
  STATUS_NEW         = 0
  STATUS_TO_VERIFY   = 1
  STATUS_VALIDATED   = 2
  STATUS_REJECTED    = 3
  STATUS_CANCELED    = 4
  STATUS_ROLLBACKED  = 5

  # Associations
  belongs_to :game
end
