# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :users_games_reputation_ranklist do
    association :game, factory: :all_game
    reputation 0
    delta_reputation 0
    rank UsersGamesReputationRanklist::RANK_UNKNOWN
    trait :user_account do
      association :user, factory: :account
    end

    trait :user_steam_user do
      association :user, factory: :steam_user
    end

    factory :account_reputation_rank, traits: [:user_account]
    factory :steam_reputation_rank, traits: [:user_steam_user]
  end
end
