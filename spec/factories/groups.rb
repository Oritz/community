# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :group do
    sequence(:name) { |n| "group#{n}" }
    description "group description"
    logo ""
    association :creator, factory: :account
  end
end
