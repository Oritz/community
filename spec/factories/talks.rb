# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :talk do
    content "talk something"
    association :creator, factory: :account
  end
end
