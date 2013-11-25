require 'spec_helper'

describe AllGame do
  let(:steam_game) { SteamGame.create!(appid: 1) }

  it "is valid with valid attributes" do
    game = AllGame.new(name: "testname")
    game.subable = steam_game
    expect(game).to be_valid
  end

  context "validate name" do
    it "is not valid without name" do
      game = AllGame.new
      game.subable = steam_game
      expect(game).not_to be_valid
    end

    it "is not valid with name longer than 255" do
      name = "s" * 256
      game = AllGame.new(name: name)
      game.subable = steam_game
      expect(game).not_to be_valid
    end
  end

  it "is not valid without subable" do
    game = AllGame.new(name: "test")
    expect(game).not_to be_valid
  end

  it "is not valid wit subable duplicated" do
    steam_game = create(:steam_game)
    game = AllGame.new(name: "test")
    game.subable = steam_game
    expect(game).not_to be_valid
  end
end
