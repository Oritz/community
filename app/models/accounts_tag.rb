class AccountsTag < ActiveRecord::Base
  belongs_to :account
  belongs_to :tag
end
