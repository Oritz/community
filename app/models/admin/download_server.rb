class Admin::DownloadServer < ActiveRecord::Base
  attr_accessible :comment, :server_ip
end
