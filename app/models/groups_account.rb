require 'sonkwo/exp'

class GroupsAccount < ActiveRecord::Base
  # Callbacks
  after_create { Sonkwo::Exp.increase("exp_add_a_grouper", self.account, self.created_at) if self.group.creator != self.account }

  # Associations
  belongs_to :group
  belongs_to :account
end
