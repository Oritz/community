# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :accounts_exp_strategy do
    account
    association :exp_strategy, factory: :exp_strategy_once
    period_count 0
    last_added_at nil
  end
end
