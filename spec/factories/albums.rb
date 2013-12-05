# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :album do
    sequence(:name) { |n| "album#{n}" }
    account
    photos_count 0
    status Album::STATUS_NORMAL
    album_type Album::TYPE_OTHER
  end
end
