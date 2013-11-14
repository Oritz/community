class GroupsTag < ActiveRecord::Base
  belongs_to :group
  belongs_to :tag
end
