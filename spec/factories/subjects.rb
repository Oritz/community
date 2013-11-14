# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :subject do
    association :post, factory: :subject_post
    title "subject title"
    content "subject content"
    group nil
  end
end
