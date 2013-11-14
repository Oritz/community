# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :conversation do
    association :first_account, factory: :account
    association :second_account, factory: :account
  end
end
