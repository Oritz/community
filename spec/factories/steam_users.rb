# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :steam_user do
    account
    sequence(:steamid) { |n| "#{n}" }
  end
end
