# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :post do
    association :creator, factory: :account
    group nil
    comment ""

    trait :deleted do
      status Post::STATUS_DELETED
    end

    trait :normal do
      status Post::STATUS_NORMAL
    end

    trait :talk do
      post_type Post::TYPE_TALK
    end

    trait :subject do
      post_type Post::TYPE_SUBJECT
    end

    trait :recommend do
      post_type Post::TYPE_RECOMMEND
    end

    factory :deleted_post, traits: [:deleted]
    factory :talk_post, traits: [:talk]
    factory :subject_post, traits: [:subject]
    factory :recommend_post, traits: [:recommend]
  end
end
