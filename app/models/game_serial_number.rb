class GameSerialNumber < ActiveRecord::Base
  # attr_accessible :title, :body
  belongs_to :game
  belongs_to :serial_type, class_name: "SerialType", foreign_key: "serial_type"
  
  STATUS_FRESH      = 0
  STATUS_ALLOCATED  = 2
  STATUS_USED       = 1
  STATUS_ALL        = 3
  STATUS            = 4 # FOR localization
end
