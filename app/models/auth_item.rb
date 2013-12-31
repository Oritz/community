require "common/common_algorithm"
class AuthItem < ActiveRecord::Base
  control_auth_item
  include CommonAlgorithm
  attr_accessible :oper_arr
  validates :name, :auth_type, :description, presence: true
  scope :roles, -> {where(auth_type: TYPE_ROLE)}
  scope :operations, -> {where(auth_type: TYPE_OPERATION)}
  scope :tasks, -> {where(auth_type: TYPE_TASK)}

  attr_writer :oper_arr
  def oper_arr=(arr)
    old_list_ids = self.children.collect{|o| o.id.to_s}
    merge_list(old_list_ids, arr) do |new_list_ids, drop_list_ids|
      new_list_ids.each do |n|
        self.add_child(AuthItem.find(n))
      end
      drop_list_ids.each do |d|
        self.remove_child(AuthItem.find(d))
      end
    end

    #add this role to administrator as a child
    if self.auth_type == TYPE_ROLE
      admin = AuthItem.where('name=?', 'administrator').first
      if admin
        admin.add_child self unless admin.has_child? self
      else
        self.errors[:base] << t('errors.have_no_administrator_now')
      end
    end      
  end
end
