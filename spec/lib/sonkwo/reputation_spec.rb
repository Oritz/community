require 'spec_helper'
require 'sonkwo/reputation'

module Sonkwo
  describe Reputation do
    let(:game) { create(:all_game) }

    it "should calculate rank and delta_reputation" do
      10.times do |i|
        create(:account_reputation_rank, game: game, reputation: i+1)
      end

      Sonkwo::Reputation.rank

      results = [
                 [UsersGamesReputationRanklist::RANK_NEWBIE, 2],
                 [UsersGamesReputationRanklist::RANK_NEWBIE, 1],
                 [UsersGamesReputationRanklist::RANK_AMATEUR, 2],
                 [UsersGamesReputationRanklist::RANK_AMATEUR, 1],
                 [UsersGamesReputationRanklist::RANK_EXPERIENCED, 2],
                 [UsersGamesReputationRanklist::RANK_EXPERIENCED, 1],
                 [UsersGamesReputationRanklist::RANK_DEDICATED, 2],
                 [UsersGamesReputationRanklist::RANK_DEDICATED, 1],
                 [UsersGamesReputationRanklist::RANK_HARDCORE, 1],
                 [UsersGamesReputationRanklist::RANK_ELITE, 0]
                ]
      items = UsersGamesReputationRanklist.all
      items.each_with_index do |item, index|
        expect(item.rank).to eq results[index][0]
        expect(item.delta_reputation).to eq results[index][1]
      end
    end
  end
end
