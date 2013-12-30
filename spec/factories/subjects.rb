# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :subject do
    title "subject title"
    content "subject content"
    main_body "main body"
    association :creator, factory: :account
  end
end
