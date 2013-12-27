require 'spec_helper'

describe Post do
  let(:creator) { create(:account) }
  let(:group) { create(:group) }

  it "is valid with valid attributes(no group)" do
    post = Post.new
    post.creator = creator

    expect(post).to be_valid
  end

  context "validate group" do
    it "is valid with group added" do
      creator.groups << group
      post = Post.new
      post.creator = creator
      post.group = group

      expect(post).to be_valid
    end

    it "is not valid with group not added" do
      post = Post.new
      post.creator = creator
      post.group = group

      expect(post).not_to be_valid
    end
  end

  context "validate comment" do
    it "is not valid with name longer than 140" do
      comment = "s" * 141
      post = Post.new(recommendation: comment)
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

  context "recommend" do
    let(:account) { create(:account) }
    let(:post) { creator(:post) }
    let!(:exp_strategy) { create(:exp_strategy_day, app_name: "exp_recommend_post") }

    it "should create a recommend post" do
      post = Post.new(recommendation: "recommendation")
      post.creator = account
      post.original = post
      post.parent = post
      post.original_author = post.creator
      expect(post).to be_valid
    end
  end

  it "should list recommended posts with accounts info"
end
