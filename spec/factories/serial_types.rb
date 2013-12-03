# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :serial_type do
    sequence(:type_name) { |n| "type_name_#{n}" }
    type_desc "type_desc"
    type_cat 0
  end
end
