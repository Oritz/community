# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :cloud_storage do
    account
    bucket_name "bucket_name"
    key "key"
    data ""

    trait :image_type do
      storage_type CloudStorage::STORAGE_TYPE_IMAGE
    end

    factory :cloud_storage_image, traits: [:image_type]
  end
end
