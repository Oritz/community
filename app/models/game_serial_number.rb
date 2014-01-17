class GameSerialNumber < ActiveRecord::Base
  attr_accessible :batch_number, :serial_type, :serial_status, :serial_number, :status, :game_id
  belongs_to :game
  belongs_to :serialtype, class_name: "SerialType", foreign_key: "serial_type"
  
  STATUS_FRESH      = 0
  STATUS_ALLOCATED  = 2
  STATUS_USED       = 1
  STATUS_ALL        = 3 # FOR localization
end
