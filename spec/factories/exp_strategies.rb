# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :exp_strategy do
    sequence(:name) { |n| "name_#{n}" }
    sequence(:app_name) { |n| "app_name_#{n}" }
    time_limit 10
    value 1
    bonus 1
    status ExpStrategy::STATUS_NORMAL
    data ""

    trait :type_once do
      period_type ExpStrategy::TYPE_ONCE
    end

    trait :type_day do
      period_type ExpStrategy::TYPE_DAY
    end

    trait :type_unlimited do
      period_type ExpStrategy::TYPE_UNLIMITED
    end

    factory :exp_strategy_once, traits: [:type_once]
    factory :exp_strategy_day, traits: [:type_day]
    factory :exp_strategy_unlimited, traits: [:type_unlimited]
  end
end
