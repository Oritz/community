# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :recommend do
    association :post, factory: :recommend_post
    association :original, factory: :talk
    association :parent, factory: :talk
    association :original_author, factory: :account
    content "recommend content"
  end
end
