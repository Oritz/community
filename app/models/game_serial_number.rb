class GameSerialNumber < ActiveRecord::Base
  # attr_accessible :title, :body
  belongs_to :game
  belongs_to :serialtype, class_name: "SerialType", foreign_key: "serial_type"
end
