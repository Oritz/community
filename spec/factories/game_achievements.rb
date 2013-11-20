# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :game_achievement do
    association :game, factory: :all_game
    name "achievement name"
    description "achievement description"
    sequence(:api_name) { |n| "api_name_#{n}" }
    lock_url "lock_url"
    unlock_url "unlock_url"
    percentage nil
    status GameAchievement::STATUS_NORMAL
  end
end
