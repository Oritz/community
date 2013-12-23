class UserGamePlayHistory < ActiveRecord::Base
  # attr_accessible :title, :body
  belongs_to :account
  belongs_to :game
end
