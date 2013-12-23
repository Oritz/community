require 'spec_helper'

describe GamePlatformUser do
  let(:game_platform) { create(:game_platform) }

  context "validate valid attributes" do
    it "is valid with valid attributes (without latest_time)" do
      game_platform_user = GamePlatformUser.new(game_platform_account: "account")
      game_platform_user.game_platform = game_platform
      expect(game_platform_user).to be_valid
    end

    it "is valid with valid attributes (with latest_time)" do
      game_platform_user = GamePlatformUser.new(game_platform_account: "account",
                                                latest_time: Time.now)
      game_platform_user.game_platform = game_platform
      expect(game_platform_user).to be_valid
    end
  end

  context "validate game_platform" do
    it "is not valid without game_platform" do
      game_platform_user = GamePlatformUser.new(game_platform_account: "account")
      expect(game_platform_user).not_to be_valid
    end
  end

  context "validate game_platform_account" do
    it "is not valid without game_platform_account" do
      game_platform_user = GamePlatformUser.new
      game_platform_user.game_platform = game_platform
      expect(game_platform_user).not_to be_valid
    end

    it "is not valid with game_platform_account longer than 255" do
      game_platform_user = GamePlatformUser.new(game_platform_account: "s" * 256)
      game_platform_user.game_platform = game_platform
      expect(game_platform_user).not_to be_valid
    end

    it "is not valid with repeated game_platform_account" do
      game_platform_user = GamePlatformUser.new(game_platform_account: "account")
      game_platform_user.game_platform = game_platform
      game_platform_user.save!

      repeated_game_platform_user = GamePlatformUser.new(game_platform_account: game_platform_user.game_platform_account)
      repeated_game_platform_user.game_platform = game_platform
      expect(repeated_game_platform_user).not_to be_valid
    end
  end

  context "validate bind_count" do
    it "is not valid without bind_count" do
      game_platform_user = GamePlatformUser.new(game_platform_account: "account")
      game_platform_user.game_platform = game_platform
      game_platform_user.bind_count = nil
      expect(game_platform_user).not_to be_valid
    end

    it "is not valid with bind_count less than 0" do
      game_platform_user = GamePlatformUser.new(game_platform_account: "account")
      game_platform_user.game_platform = game_platform
      game_platform_user.bind_count = -1
      expect(game_platform_user).not_to be_valid
    end

    it "is not valid with bind_count which is not an integer" do
      game_platform_user = GamePlatformUser.new(game_platform_account: "account")
      game_platform_user.game_platform = game_platform
      game_platform_user.bind_count = 1.0
      expect(game_platform_user).not_to be_valid
    end
  end

  context "validate game_count" do
    it "is not valid without game_count" do
      game_platform_user = GamePlatformUser.new(game_platform_account: "account")
      game_platform_user.game_platform = game_platform
      game_platform_user.game_count = nil
      expect(game_platform_user).not_to be_valid
    end

    it "is not valid with bind_count less than 0" do
      game_platform_user = GamePlatformUser.new(game_platform_account: "account")
      game_platform_user.game_platform = game_platform
      game_platform_user.game_count = -1
      expect(game_platform_user).not_to be_valid
    end

    it "is not valid with bind_count which is not an integer" do
      game_platform_user = GamePlatformUser.new(game_platform_account: "account")
      game_platform_user.game_platform = game_platform
      game_platform_user.game_count = 1.0
      expect(game_platform_user).not_to be_valid
    end
  end

  context "validate status" do
    it "is not valid without status" do
      game_platform_user = GamePlatformUser.new(game_platform_account: "account")
      game_platform_user.game_platform = game_platform
      game_platform_user.status = nil
      expect(game_platform_user).not_to be_valid
    end

    it "is not valid with bind_count less than 0" do
      game_platform_user = GamePlatformUser.new(game_platform_account: "account")
      game_platform_user.game_platform = game_platform
      game_platform_user.status = -1
      expect(game_platform_user).not_to be_valid
    end

    it "is not valid with bind_count which is not an integer" do
      game_platform_user = GamePlatformUser.new(game_platform_account: "account")
      game_platform_user.game_platform = game_platform
      game_platform_user.status = 1.0
      expect(game_platform_user).not_to be_valid
    end
  end
end
