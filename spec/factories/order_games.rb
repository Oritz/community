# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :order_game do
    account
    game
    sequence(:order_id) { |n| n }
    drupal_account_id 1
  end
end
