# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :talk do
    association :post, factory: :talk_post
    content "talk something"
  end
end
