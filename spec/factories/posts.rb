# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :post do
    association :creator, factory: :account
    group nil
    comment ""
    status Post::STATUS_NORMAL
    association :detail, factory: :talk
  end
end
