require 'spec_helper'

describe SteamGame do
  it "is valid with valid attributes" do
    steam_game = SteamGame.new(appid: Time.now.to_i)
    expect(steam_game).to be_valid
  end

  it "is not valid without appid" do
    steam_game = SteamGame.new
    expect(steam_game).not_to be_valid
  end

  it "is not valid with appid which is not an integer" do
    steam_game = SteamGame.new(appid: "invalid")
    expect(steam_game).not_to be_valid
  end
end
