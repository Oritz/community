require 'spec_helper'

describe Post do
  let(:creator) { create(:account) }
  let(:group) { create(:group) }
  let!(:exp_post_subject) { create(:exp_strategy_day, app_name: "exp_post_subject") }
  let!(:exp_post_talk) { create(:exp_strategy_day, app_name: "exp_post_talk") }
  let!(:exp_recommend_post) { create(:exp_strategy_day, app_name: "exp_recommend_post") }

  it "is valid with valid attributes(no group)" do
    post = Post.new(content: "content")
    post.post_type = Post::TYPE_TALK
    post.creator = creator
    post.content = "content"

    expect(post).to be_valid
  end

  context "validate group" do
    it "is valid with group added" do
      creator.groups << group
      post = Post.new(content: "content")
      post.post_type = Post::TYPE_TALK
      post.creator = creator
      post.group = group

      expect(post).to be_valid
    end

    it "is not valid with group not added" do
      post = Post.new
      post.post_type = Post::TYPE_TALK
      post.creator = creator
      post.group = group

      expect(post).not_to be_valid
    end
  end

  context "validate content" do
    it "is not valid with name longer than 140" do
      content = "s" * 141
      post = Post.new(content: content)
      post.post_type = Post::TYPE_TALK
      post.creator = creator
      expect(post).not_to be_valid
    end
  end

  context "validate privilege" do
  end

  context "validate status" do
  end

  context "validate comment_count" do
  end

  context "validate recommend_count" do
  end

  context "validate like_count" do
  end

  context "validate creator" do
  end

  context "with accounts" do
    it "should be liked by a user"
    it "should be unliked by a user"
  end

  it "should list recommended posts"

  context "recommend" do
    let(:original_post) { create(:post) }

    it "should create a recommend post" do
      post = Post.new(content: "recommendation")
      post.post_type = Post::TYPE_RECOMMEND
      post.creator = creator
      post.original = original_post
      post.parent = original_post
      post.original_author = original_post.creator

      post.save!
      expect(post.original.recommend_count).to eq 1
      expect(creator.recommend_count).to eq 1
      expect(creator.exp).to eq exp_recommend_post.value
    end
  end

  context "talk" do
    it "should create a talk without image" do
      post = Post.new(content: "content")
      post.post_type = Post::TYPE_TALK
      post.creator = creator

      post.save!
      expect(Post.first).to eq post
      expect(creator.talk_count).to eq 1
      expect(creator.exp).to eq exp_post_talk.value
    end

    it "should create a talk with cloud_storage_id" do
      cloud_storage = create(:cloud_storage_image)
      post = Post.new(content: "content", cloud_storage_id: cloud_storage.id)
      post.post_type = Post::TYPE_TALK
      post.creator = creator

      post.save!
      post_image = PostImage.where(post_id: post.id).first
      expect(post_image).not_to be_nil
    end
  end

  context "subject" do
    it "should create a subject" do
      group.accounts << creator
      post = Post.new(
                      content: "content",
                      main_body: "main body"
                      )
      post.creator = creator
      post.group = group
      post.post_type = Post::TYPE_SUBJECT
      expect(post).to be_valid
      expect { post.save! }.to change { creator.exp }.by(exp_post_subject.value)
      expect(creator.subject_count).to eq 1
      expect(group.subject_count).to eq 1
    end

    it "should create a pending subject" do
      post = Post.new
      post.creator = creator
      post.post_type = Post::TYPE_SUBJECT
      post.status = Post::STATUS_PENDING

      expect(post).to be_valid
      expect { post.save! }.to change { creator.exp }.by(0)
      expect(creator.subject_count).to eq 0
    end

    it "should not re-create a new pending subject" do
      pending_post = create(:pending_post, creator: creator)

      post = Post.new
      post.creator = creator
      post.post_type = Post::TYPE_SUBJECT
      post.status = Post::STATUS_PENDING
      expect(post).not_to be_valid
    end

    it "should update a pending subject" do
      pending_post = create(:pending_post, creator: creator, content: "pending", main_body: "pending")

      pending_post.content = "content"
      pending_post.main_body = "main body"
      pending_post.save!

      expect(pending_post.content).to eq "content"
      expect(pending_post.main_body).to eq "main body"
      expect(creator.subject_count).to eq 0
      expect(creator.exp).to eq 0
    end

    it "should update a posted subject" do
      post = create(:post, creator: creator, post_type: Post::TYPE_SUBJECT, main_body: "main body")
      post.content = "updated content"
      post.main_body = "updated main body"
      post.save!

      expect(post.content).to eq "updated content"
      expect(post.main_body).to eq "updated main body"
      expect(creator.subject_count).to eq 1
      expect(creator.exp).to eq exp_post_subject.value
    end

    it "should post a pending subject" do
      pending_post = create(:pending_post, creator: creator)

      expect(pending_post.post_pending).to be_true
      expect(creator.subject_count).to eq 1
      expect(creator.exp).to eq exp_post_subject.value
    end
  end
end
