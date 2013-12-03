# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user_game_serial do
    account
    game
    association :serialtype, factory: :serial_type
    sequence(:serial_number) { |n| "serial_number_#{n}" }
  end
end
