# Read about factories at https://github.com/thoughtbot/factory_girl
FactoryGirl.define do
  factory :account do
    sequence(:email) { |n| "email#{n}@sonkwo.com" }
    password "12345678"
    password_confirmation "12345678"
    confirmed_at Time.now
    gender 1
    sequence(:nick_name) { |n| "test#{n}" }
    groups []
  end
end
