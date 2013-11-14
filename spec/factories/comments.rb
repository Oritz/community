# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :comment do
    association :post, factory: :post
    association :post_author, factory: :account
    original nil
    original_author nil
    comment "comment"
    association :creator, factory: :account
  end
end
