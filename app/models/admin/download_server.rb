class Admin::DownloadServer < ActiveRecord::Base
  self.table_name = 'download_servers'
  attr_accessible :comment, :server_ip
  validates :comment, :server_ip, presence: true
end
