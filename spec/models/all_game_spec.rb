require 'spec_helper'

describe AllGame do
  let(:steam_game) { SteamGame.create!(appid: 1) }

  it "is valid with valid attributes" do
    game = AllGame.new(name: "testname")
    game.subable = steam_game
    expect(game).to be_valid
  end

  it "is valid without subable" do
    game = AllGame.new(name: "testname")
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

  context "validate image" do
    it "is not valid without image" do
      game = AllGame.new(name: "game")
      game.subable = steam_game
      game.image = nil
      expect(game).not_to be_valid
    end

    it "is not valid with image longer than 255" do
      image = "s" * 256
      game = AllGame.new(name: "game")
      game.subable = steam_game
      game.image = image
      expect(game).not_to be_valid
    end
  end

  it "is not valid wit subable duplicated" do
    steam_game = create(:steam_game)
    game = AllGame.new(name: "test")
    game.subable = steam_game
    expect(game).not_to be_valid
  end

  context "validate belong_to_account" do
    let(:game) { create(:all_game) }
    let(:account) { create(:account) }
    let(:steam_user) { create(:steam_user, account: account) }
    let(:game_steam) { create(:steam_game) }

    it "should list games are belong to an account(with steamid binded)" do
      account.other_games << game

      games = AllGame.belong_to_account(account)
      expect(games.count).to eq account.other_games.count
    end

    it "shoud list games are belong to an account(without steamid binded)" do
      account.other_games << game
      steam_user.games << game_steam.game

      games = AllGame.belong_to_account(account)
      expect(games.count).to eq account.other_games.count + steam_user.games.count
    end
  end
end
