require 'spec_helper'

describe GamePlatform do
  context "validate with valid attributes" do
    it "is valid with api_key" do
      game_platform = GamePlatform.new(
                                       name: "test",
                                       api_key: "api_key"
                                       )
      expect(game_platform).to be_valid
    end

    it "is valid without api_key" do
      game_platform = GamePlatform.new(name: "test")
      expect(game_platform).to be_valid
    end
  end

  context "validate name" do
    it "is not valid without name" do
      game_platform = GamePlatform.new(api_key: "api_key")
      expect(game_platform).not_to be_valid
    end

    it "is not valid with name longer than 31" do
      game_platform = GamePlatform.new(name: "s" * 32)
      expect(game_platform).not_to be_valid
    end

    it "is not valid with name repeated" do
      game_platform = GamePlatform.new(name: "test")
      game_platform.save!
      repeated_game_platform = GamePlatform.new(name: game_platform.name)
      expect(repeated_game_platform).not_to be_valid
    end
  end

  context "validate api_key" do
    it "is not valid with api_key longer than 255" do
      game_platform = GamePlatform.new(name: "test",
                                       api_key: "s" * 256)
      expect(game_platform).not_to be_valid
    end
  end

  context "validate platform_type" do
    it "is not valid without platform_type" do
      game_platform = GamePlatform.new(name: "test")
      game_platform.platform_type = nil
      expect(game_platform).not_to be_valid
    end

    it "it not valid with platform_type which is not an integer" do
      game_platform = GamePlatform.new(name: "test")
      game_platform.platform_type = 1.0
      expect(game_platform).not_to be_valid
    end
  end
end
