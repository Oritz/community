class AccountGamePlatformUser < ActiveRecord::Base
  belongs_to :account
  belongs_to :game_platform_user
end
