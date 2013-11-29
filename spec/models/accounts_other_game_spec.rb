require 'spec_helper'

describe AccountsOtherGame do
  let(:account) { create(:account) }
  let(:game) { create(:all_game) }

  it "is valid with valid attributes" do
    accounts_other_game = AccountsOtherGame.new
    accounts_other_game.account = account
    accounts_other_game.game = game

    expect(accounts_other_game).to be_valid
  end

  it "should add an item into users_games_reputation_ranklist" do
    accounts_other_game = AccountsOtherGame.new
    accounts_other_game.account = account
    accounts_other_game.game = game
    accounts_other_game.save!

    item = UsersGamesReputationRanklist.where(game_id: game.id, user_id: account.id, user_type: "Account").first
    expect(item).not_to be_nil
  end

  context "other test"
end
