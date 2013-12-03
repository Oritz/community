# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :client_update do
    sequence(:major_ver) { |n| n }
    sequence(:minor_ver) { |n| n }
    sequence(:tiny_ver) { |n| n }
    full_pkg_file ""
    status ClientUpdate::STATUS_RELEASED
    full_pkg_digest ""
  end
end
