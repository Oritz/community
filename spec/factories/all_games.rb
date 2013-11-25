# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :all_game do
    sequence(:name) { |n| "game#{n}" }
    status AllGame::STATUS_NORMAL
    subable nil

    #trait :game_steam_subable do
    #  association :subable, factory: :steam_game
    #end

    #factory :game_with_steam, traits: [:game_steam_subable]
  end
end
