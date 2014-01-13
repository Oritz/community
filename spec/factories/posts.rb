# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :post do
    association :creator, factory: :account
    group nil
    status Post::STATUS_NORMAL
    post_type Post::TYPE_TALK
    content "content"
    main_body nil

    trait :talk_type do
      post_type Post::TYPE_TALK
      cloud_storage_id nil
    end

    trait :subject_type do
      post_type Post::TYPE_SUBJECT
      main_body "main body"
    end

    trait :status_deleted do
      status Post::STATUS_DELETED
    end

    factory :talk, traits: [:talk_type]
    factory :subject, traits: [:subject_type]
    factory :recommend do
      post_type Post::TYPE_RECOMMEND
      association :original, factory: :talk
      association :parent, factory: :talk
      association :original_author, factory: :account
    end

    factory :deleted_post, traits: [:status_deleted]

    factory :pending_post do
      status Post::STATUS_PENDING
      post_type Post::TYPE_SUBJECT
      content "pending content"
      main_body "pending main body"
    end
  end
end
