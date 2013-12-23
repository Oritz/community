# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :steam_game_achievement do
    sequence(:api_name) { |n| "api_name#{n}" }
    percent 0.0
    association :steam_game, factory: :steam_game

    after(:create) do |a|
      FactoryGirl.create(:game_achievement, game: a.steam_game.game, subable: a)
    end
  end
end
