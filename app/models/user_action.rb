class UserAction < ActiveRecord::Base
  # attr_accessible :title, :body
  ACTION_CLIENT_LOGIN = 1
  ACTION_CLIENT_LOGOUT = 2
  ACTION_GAME_START = 3
  ACTION_GAME_EXIT = 4
  ACTION_PAGE_OPEN = 5
  ACTION_PAGE_CLOSE = 6
end
