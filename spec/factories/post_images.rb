# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :post_image do
    post
    cloud_storage
    comment "comment"
  end
end
