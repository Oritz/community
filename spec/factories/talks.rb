# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :talk do
    content "talk something"
    creator nil
  end
end
