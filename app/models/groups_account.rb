class GroupsAccount < ActiveRecord::Base
  belongs_to :group
  belongs_to :account
end
