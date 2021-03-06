# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :group do
    sequence(:name) { |n| "group#{n}" }
    description "group description"
    logo "logo"
    talk_count 0
    subject_count 0
    recommend_count 0
    association :creator, factory: :account
  end
end
