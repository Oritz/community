require 'spec_helper'

describe GameAchievement do
  let(:game) { create(:all_game) }

  it "is valid with valid attributes" do
    game_achievement = GameAchievement.new(name: "test name",
                                           description: "description",
                                           api_name: "apiname",
                                           lock_url: "lock_url",
                                           unlock_url: "unlock_url",
                                           percentage: 1.3)
    game_achievement.game = game
    expect(game_achievement).to be_valid
  end

  it "is not valid without game" do
    game_achievement = GameAchievement.new(name: "test name",
                                           description: "description",
                                           api_name: "apiname",
                                           lock_url: "lock_url",
                                           unlock_url: "unlock_url",
                                           percentage: 1.3)
    expect(game_achievement).not_to be_valid
  end

  context "validate name" do
    it "is not valid without name" do
      game_achievement = GameAchievement.new(description: "description",
                                             api_name: "apiname",
                                             lock_url: "lock_url",
                                             unlock_url: "unlock_url",
                                             percentage: 1.3)
      game_achievement.game = game
      expect(game_achievement).not_to be_valid
    end

    it "is not valid with name longer than 255" do
      name = "s" * 256
      game_achievement = GameAchievement.new(name: name,
                                             description: "description",
                                             api_name: "apiname",
                                             lock_url: "lock_url",
                                             unlock_url: "unlock_url",
                                             percentage: 1.3)
      game_achievement.game = game
      expect(game_achievement).not_to be_valid
    end
  end

  it "is not valid without description" do
      game_achievement = GameAchievement.new(name: "test name",
                                             api_name: "apiname",
                                             lock_url: "lock_url",
                                             unlock_url: "unlock_url",
                                             percentage: 1.3)
      game_achievement.game = game
      expect(game_achievement).not_to be_valid
  end

  context "validate api_name" do
    it "is not valid without api_name" do
      game_achievement = GameAchievement.new(name: "test name",
                                             description: "description",
                                             lock_url: "lock_url",
                                             unlock_url: "unlock_url",
                                             percentage: 1.3)
      game_achievement.game = game
      expect(game_achievement).not_to be_valid
    end

    it "is not valid with api_name longer than 255" do
      api_name = "s" * 256
      game_achievement = GameAchievement.new(name: "test name",
                                             description: "description",
                                             api_name: api_name,
                                             lock_url: "lock_url",
                                             unlock_url: "unlock_url",
                                             percentage: 1.3)
      game_achievement.game = game
      expect(game_achievement).not_to be_valid
    end

    it "is not valid with the same api_name and game_id" do
      game_achievement = GameAchievement.new(name: "test name",
                                             description: "description",
                                             api_name: "apiname",
                                             lock_url: "lock_url",
                                             unlock_url: "unlock_url",
                                             percentage: 1.3)
      game_achievement.game = game
      game_achievement.save!

      another_game_achievement = GameAchievement.new(name: "test name",
                                                     description: "description",
                                                     api_name: "apiname",
                                                     lock_url: "lock_url",
                                                     unlock_url: "unlock_url",
                                                     percentage: 1.3)
      expect(another_game_achievement).not_to be_valid
    end
  end

  context "validate lock_url" do
    it "is not valid without lock_url" do
      game_achievement = GameAchievement.new(name: "test name",
                                             description: "description",
                                             api_name: "apiname",
                                             unlock_url: "unlock_url",
                                             percentage: 1.3)
      game_achievement.game = game
      expect(game_achievement).not_to be_valid
    end

    it "is not valid with lock_url longer than 255" do
      lock_url = "s" * 256
      game_achievement = GameAchievement.new(name: "test name",
                                             description: "description",
                                             api_name: "apiname",
                                             lock_url: lock_url,
                                             unlock_url: "unlock_url",
                                             percentage: 1.3)
      game_achievement.game = game
      expect(game_achievement).not_to be_valid
    end
  end

  context "validate unlock_url" do
    it "is not valid without unlock_url" do
      game_achievement = GameAchievement.new(name: "test name",
                                             description: "description",
                                             api_name: "apiname",
                                             lock_url: "lock_url",
                                             percentage: 1.3)
      game_achievement.game = game
      expect(game_achievement).not_to be_valid
    end

    it "is not valid with unlock_url longer than 255" do
      unlock_url = "s" * 256
      game_achievement = GameAchievement.new(name: "test name",
                                             description: "description",
                                             api_name: "apiname",
                                             lock_url: "lock_url",
                                             unlock_url: unlock_url,
                                             percentage: 1.3)
      game_achievement.game = game
      expect(game_achievement).not_to be_valid
    end
  end

  context "validate percentage" do
    it "is valid without percentage" do
      game_achievement = GameAchievement.new(name: "test name",
                                             description: "description",
                                             api_name: "apiname",
                                             lock_url: "lock_url",
                                             unlock_url: "unlock_url")
      game_achievement.game = game
      expect(game_achievement).to be_valid
    end

    it "is not valid with percentage less than 0.0" do
      game_achievement = GameAchievement.new(name: "test name",
                                             description: "description",
                                             api_name: "apiname",
                                             lock_url: "lock_url",
                                             unlock_url: "unlock_url",
                                             percentage: -0.1)
      game_achievement.game = game
      expect(game_achievement).not_to be_valid
    end

    it "is not valid with percentage larger than 100.0" do
      game_achievement = GameAchievement.new(name: "test name",
                                             description: "description",
                                             api_name: "apiname",
                                             lock_url: "lock_url",
                                             unlock_url: "unlock_url",
                                             percentage: 100.1)
      game_achievement.game = game
      expect(game_achievement).not_to be_valid
    end

    it "is valid with percentage eq 100.0" do
      game_achievement = GameAchievement.new(name: "test name",
                                             description: "description",
                                             api_name: "apiname",
                                             lock_url: "lock_url",
                                             unlock_url: "unlock_url",
                                             percentage: 100.0)
      game_achievement.game = game
      expect(game_achievement).to be_valid
    end

    it "is valid with percentage eq 0.0" do
      game_achievement = GameAchievement.new(name: "test name",
                                             description: "description",
                                             api_name: "apiname",
                                             lock_url: "lock_url",
                                             unlock_url: "unlock_url",
                                             percentage: 0.0)
      game_achievement.game = game
      expect(game_achievement).to be_valid
    end
  end
end
