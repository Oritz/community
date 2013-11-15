require 'spec_helper'

describe Post do
  let(:creator) { create(:account) }

  it "is valid with valid attributes" do
    post = Post.new(comment: "comment")
    post.creator = creator
    post.post_type = Post::TYPE_TALK

    expect(post).to be_valid
  end

  context "validate comment" do
    it "is not valid with name longer than 140" do
      comment = "s" * 141
      post = Post.new(comment: comment)
      post.creator = creator
      expect(post).not_to be_valid
    end
  end

  context "validate post_type" do
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

  it "should list recommended posts with accounts info"
end
