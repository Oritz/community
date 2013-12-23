class UserGameSerial < ActiveRecord::Base
  # attr_accessible :title, :body
  belongs_to :account
  belongs_to :game
  belongs_to :serialtype, class_name: "SerialType", foreign_key: "serial_type"
end
