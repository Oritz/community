require 'spec_helper'

describe SteamUser do
  let(:account) { create(:account) }

  context "valid attributes" do
    it "is valid with all fields" do
      steam_user = SteamUser.new(
                                 steamid: "76561198082595090",
                                 personaname: "test",
                                 profile_url: "test_url",
                                 avatar: "test_avatar",
                                 communityvisibilitystate: 1,
                                 profilestate: 1,
                                 lastlogoff: Time.now.to_i,
                                 commentpermission: 1,
                                 realname: "test",
                                 primaryclanid: "1234",
                                 loccountrycode: "US",
                                 locstatecode: "WA",
                                 loccityid: 123,
                                 timecreated: Time.now.to_i
                                 )
      steam_user.account = account
      expect(steam_user).to be_valid
    end

    it "is valid with some fields" do
      steam_user = SteamUser.new(
                                 steamid: "76561198082595090",
                                 personaname: "test",
                                 profile_url: "test_url",
                                 avatar: "test_avatar",
                                 communityvisibilitystate: 1,
                                 profilestate: 1
                                 )
      expect(steam_user).to be_valid
    end

    it "is valid with steamid" do
      steam_user = SteamUser.new(steamid: "76561198082595090")
      steam_user.account = account
      expect(steam_user).to be_valid
    end
  end

  context "with invalidate attributes"
end
