class Admin::DownloadServer < ActiveRecord::Base
  attr_accessible :comment, :server_ip
  validates :comment, :server_ip, presence: true
end
