# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :game_platform do
    sequence(:name) { |n| "platform#{n}" }
    api_key "api_key"
  end
end
