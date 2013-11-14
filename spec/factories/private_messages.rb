# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :private_message do
    conversation
    content "say something"
    read_at nil
    first_deleted_at nil
    second_deleted_at nil
  end
end
