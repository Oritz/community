require 'spec_helper'

describe SteamFriend do
  let(:steam_user) { create(:steam_user) }
  let(:friend) { create(:steam_user) }

  it "is valid with valid attributes" do
    steam_friend = SteamFriend.new(friend_since: Time.now.to_i)
    steam_friend.steam_user = steam_user
    steam_friend.friend = friend

    expect(steam_friend).to be_valid
  end

  it "is not valid without steam_user" do
    steam_friend = SteamFriend.new(friend_since: Time.now.to_i)
    steam_friend.friend = friend

    expect(steam_friend).not_to be_valid
  end

  it "is not valid without friend" do
    steam_friend = SteamFriend.new(friend_since: Time.now.to_i)
    steam_friend.steam_user = steam_user

    expect(steam_friend).not_to be_valid
  end

  it "is not valid without friend_since" do
    steam_friend = SteamFriend.new(friend_since: Time.now.to_i)
    steam_friend.friend_since = nil
    steam_friend.steam_user = steam_user
    steam_friend.friend = friend

    expect(steam_friend).not_to be_valid
  end

  it "is not valid with friend_since is not an integer" do
    steam_friend = SteamFriend.new(friend_since: Time.now.to_i)
    steam_friend.friend_since = "notinteger"
    steam_friend.steam_user = steam_user
    steam_friend.friend = friend

    expect(steam_friend).not_to be_valid
  end

  it "should failed to create a new record if they already are friends" do
    steam_friend = SteamFriend.new(friend_since: Time.now.to_i)
    steam_friend.steam_user = steam_user
    steam_friend.friend = friend
    steam_friend.save!

    new_steam_friend = SteamFriend.new
    new_steam_friend.steam_user = steam_user
    new_steam_friend.friend = friend
    new_steam_friend.save
    expect(new_steam_friend.id).to eq nil

    new_steam_friend = SteamFriend.new
    new_steam_friend.steam_user = friend
    new_steam_friend.friend = steam_user
    new_steam_friend.save
    expect(new_steam_friend.id).to eq nil
  end
end
