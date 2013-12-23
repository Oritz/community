require 'spec_helper'

describe SteamGameAchievement do
  let(:steam_game) { create(:steam_game) }

  context "validate valid attributes" do
    it "is valid without percent" do
      steam_game_achievement = SteamGameAchievement.new(api_name: "test")
      steam_game_achievement.steam_game = steam_game
      expect(steam_game_achievement).to be_valid
    end

    it "is valid with percnet" do
      steam_game_achievement = SteamGameAchievement.new(api_name: "test", percent: 1.0)
      steam_game_achievement.steam_game = steam_game
      expect(steam_game_achievement).to be_valid
    end
  end

  it "is not valid without steam_game" do
    steam_game_achievement = SteamGameAchievement.new(api_name: "test")
    expect(steam_game_achievement).not_to be_valid
  end

  context "validate api_name" do
    it "is not valid without api_name" do
      steam_game_achievement = SteamGameAchievement.new
      steam_game_achievement.steam_game = steam_game
      expect(steam_game_achievement).not_to be_valid
    end

    it "is not valid with api_name longer than 255" do
      steam_game_achievement = SteamGameAchievement.new(api_name: "s" * 256)
      steam_game_achievement.steam_game = steam_game
      expect(steam_game_achievement).not_to be_valid
    end

    it "is not valid with duplicated api_name and steam_game" do
      exist_game_achievement = create(:steam_game_achievement)
      steam_game_achievement = SteamGameAchievement.new(api_name: exist_game_achievement.api_name)
      steam_game_achievement.steam_game = exist_game_achievement.steam_game
      expect(steam_game_achievement).not_to be_valid
    end
  end

  context "validate percent" do
    it "is not valid with percent which is not an integer" do
      steam_game_achievement = SteamGameAchievement.new(api_name: "test", percent: "string")
      steam_game_achievement.steam_game = steam_game
      expect(steam_game_achievement).not_to be_valid
    end

    it "is not valid with percent which is smaller than 0.0" do
      steam_game_achievement = SteamGameAchievement.new(api_name: "test", percent: -1.0)
      steam_game_achievement.steam_game = steam_game
      expect(steam_game_achievement).not_to be_valid
    end

    it "is not valid with percent which is bigger than 100.0" do
      steam_game_achievement = SteamGameAchievement.new(api_name: "test", percent: 101.0)
      steam_game_achievement.steam_game = steam_game
      expect(steam_game_achievement).not_to be_valid
    end
  end
end
