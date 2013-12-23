# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :game_platform_user do
    game_platform
    sequence(:game_platform_account) { |n| "account#{n}" }
  end
end
