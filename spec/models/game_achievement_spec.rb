require 'spec_helper'

describe GameAchievement do
  let(:steam_game) { create(:steam_game) }
  let(:game) { steam_game.game }
  let(:steam_game_achievement) do
    a = SteamGameAchievement.new(api_name: "api_name")
    a.steam_game = steam_game
    a.save!
    a
  end

  it "is valid with valid attributes" do
    game_achievement = GameAchievement.new(name: "test name",
                                           description: "description",
                                           lock_url: "lock_url",
                                           unlock_url: "unlock_url")
    game_achievement.game = game
    game_achievement.subable = steam_game_achievement
    expect(game_achievement).to be_valid
  end

  it "is not valid without game" do
    game_achievement = GameAchievement.new(name: "test name",
                                           description: "description",
                                           lock_url: "lock_url",
                                           unlock_url: "unlock_url")
    game_achievement.subable = steam_game_achievement
    expect(game_achievement).not_to be_valid
  end

  context "validate name" do
    it "is not valid without name" do
      game_achievement = GameAchievement.new(description: "description",
                                             lock_url: "lock_url",
                                             unlock_url: "unlock_url")
      game_achievement.game = game
      game_achievement.subable = steam_game_achievement
      expect(game_achievement).not_to be_valid
    end

    it "is not valid with name longer than 255" do
      name = "s" * 256
      game_achievement = GameAchievement.new(name: name,
                                             description: "description",
                                             lock_url: "lock_url",
                                             unlock_url: "unlock_url")
      game_achievement.game = game
      game_achievement.subable = steam_game_achievement
      expect(game_achievement).not_to be_valid
    end
  end

  it "is not valid without description" do
      game_achievement = GameAchievement.new(name: "test name",
                                             lock_url: "lock_url",
                                             unlock_url: "unlock_url")
      game_achievement.game = game
      game_achievement.subable = steam_game_achievement
      expect(game_achievement).not_to be_valid
  end

  context "validate lock_url" do
    it "is not valid without lock_url" do
      game_achievement = GameAchievement.new(name: "test name",
                                             description: "description",
                                             unlock_url: "unlock_url")
      game_achievement.game = game
      game_achievement.subable = steam_game_achievement
      expect(game_achievement).not_to be_valid
    end

    it "is not valid with lock_url longer than 255" do
      lock_url = "s" * 256
      game_achievement = GameAchievement.new(name: "test name",
                                             description: "description",
                                             lock_url: lock_url,
                                             unlock_url: "unlock_url")
      game_achievement.game = game
      game_achievement.subable = steam_game_achievement
      expect(game_achievement).not_to be_valid
    end
  end

  context "validate unlock_url" do
    it "is not valid without unlock_url" do
      game_achievement = GameAchievement.new(name: "test name",
                                             description: "description",
                                             lock_url: "lock_url")
      game_achievement.game = game
      game_achievement.subable = steam_game_achievement
      expect(game_achievement).not_to be_valid
    end

    it "is not valid with unlock_url longer than 255" do
      unlock_url = "s" * 256
      game_achievement = GameAchievement.new(name: "test name",
                                             description: "description",
                                             lock_url: "lock_url",
                                             unlock_url: unlock_url)
      game_achievement.game = game
      game_achievement.subable = steam_game_achievement
      expect(game_achievement).not_to be_valid
    end
  end

  it "is not valid without subable" do
    game_achievement = GameAchievement.new(name: "test name",
                                           description: "description",
                                           lock_url: "lock_url",
                                           unlock_url: "unlock_url")
    game_achievement.game = game
    expect(game_achievement).not_to be_valid
  end

  it "is not valid with duplicated subables" do
    exist_game_achievement = create(:steam_game_achievement)
    game_achievement = GameAchievement.new(name: "test name",
                                           description: "description",
                                           lock_url: "lock_url",
                                           unlock_url: "unlock_url")
    game_achievement.game = game
    game_achievement.subable = exist_game_achievement
    expect(game_achievement).not_to be_valid
  end
end
