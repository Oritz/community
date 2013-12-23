# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :game_serial_number do
    game
    association :serialtype, factory: :serial_type
    batch_number 1
    sequence(:serial_number) { |n| "serial_number_#{n}" }
    status 0
  end
end
