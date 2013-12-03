class ClientError < ActiveRecord::Base
  # attr_accessible :title, :body
  attr_accessible :err_msg, :account_id
end
