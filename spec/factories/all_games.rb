# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :all_game do
    sequence(:name) { |n| "game#{n}" }
    game_type AllGame::TYPE_OFFICAL
    status AllGame::STATUS_NORMAL
  end
end
