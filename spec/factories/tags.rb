# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :tag do
    sequence(:name) { |n| "tag#{n}" }

    groups {[FactoryGirl.create(:group)]}
  end
end
