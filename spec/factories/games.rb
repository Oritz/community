# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :game do
    sequence(:title) { |n| "title#{n}" }
    sequence(:alias_name) { |n| "alias_name#{n}" }
    dir_name "dir_name"
    description "description"
    status Game::STATUS_NORMAL
    game_type Game::TYPE_GAME
    sell_price 0.0
    list_price 0.0
    downloadable 1

    trait :dlc do
      association :parent, factory: :game
    end

    factory :game_dlc, traits: [:dlc]
  end
end
