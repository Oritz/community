require 'spec_helper'

describe Comment do
  let(:creator) { create(:account) }
  let(:talk) { create(:talk) }
  let(:post) { talk.post }

  it "is valid with valid attributes" do
    comment = Comment.new(comment: "comment")
    comment.creator = creator
    comment.post = post
    comment.post_author = post.creator
    expect(comment).to be_valid
  end

  context "validate comment" do
    it "is not valid without comment" do
      comment = Comment.new(comment: nil)
      comment.creator = creator
      comment.post = post
      comment.post_author = post.creator
      expect(comment).not_to be_valid
    end

    it "is not valid with comment longer than 140" do
      s = "s" * 141
      comment = Comment.new(comment: s)
      comment.creator = creator
      comment.post = post
      comment.post_author = post.creator
      expect(comment).not_to be_valid
    end
  end

  context "validate creator" do
    it "is not valid without creator" do
      comment = Comment.new(comment: "comment")
      comment.creator = nil
      comment.post = post
      comment.post_author = post.creator
      expect(comment).not_to be_valid
    end
  end

  context "validate post" do
    it "is not valid without post" do
      comment = Comment.new(comment: "comment")
      comment.creator = creator
      comment.post = nil
      comment.post_author = post.creator
      expect(comment).not_to be_valid
    end
  end

  context "validate post author" do
    it "is not valid without post author" do
      comment = Comment.new(comment: "comment")
      comment.creator = creator
      comment.post = post
      comment.post_author = nil
      expect(comment).not_to be_valid
    end
  end

  it "should list comments of a post sort by commented time" do
    comments = build_list(:comment, 25, post: post, post_author: post.creator)
    now = Time.now
    comments.each_with_index do |c, index|
      Timecop.freeze(now + 1000 * index)
      c.save
      Timecop.return
    end
    expect(Comment.of_a_post(post)).to eq comments.reverse
  end

  it "should list comments commented by a certain user and sorted by time"

  it "should list comments commented to a certain user and sorted by time"
end
