class AccountsLikePost < ActiveRecord::Base
  acts_as_notificable callbacks: ["after_create"], slot: "liked", from: "account", tos: ["post.creator"]
  belongs_to :account
  belongs_to :post
end
