class UserEnv < ActiveRecord::Base
  attr_accessible :account_id, :machine_id, :os, :cpu, :ram, :hdd, :graphics_card, :screen_w, :screen_h, :dx_ver_major, :dx_ver_minor, :dx_ver_tiny, :dot_net_ver_major, :dot_net_ver_minor, :dot_net_ver_tiny, :vc_rt_ver_major, :vc_rt_ver_minor, :mac_address

  # Associations
  belongs_to :account

  # Methods
end
