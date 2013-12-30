require 'spec_helper'

describe Talk do
  let(:account) { create(:account) }
  let(:cloud_storage) { create(:cloud_storage) }

  it "should create a talk and a post at the same time" do
    talk = Talk.new(content: "content")
    talk.creator = account

    talk.save!
    expect(Talk.first).to eq talk
    expect(Post.first).to eq talk.post
    expect(account.talk_count).to eq 1
  end

  it "should create a new item with group" do
    group = create(:group, creator: account)

    talk = Talk.new(content: "content")
    talk.group = group
    talk.creator = account

    talk.save!
    expect(group.talk_count).to eq 1
  end

  it "should create a new item without image_url" do
    talk = Talk.new(content: "content")
    talk.creator = account

    expect { talk.save! }.not_to raise_error
  end

  it "should create a new item with cloud_storage_id" do
    talk = Talk.new(content: "content", cloud_storage_id: cloud_storage.id)
    talk.creator = account
    talk.save!

    post_image = PostImage.where(post_id: talk.post.id).first
    expect(post_image).not_to be_nil
  end

  it "should create post_image while fill image_url" do
    url = "http://bucket_name.u.qiniudn.com/key"
    talk = Talk.new(content: "content", image_url: url)
    talk.creator = account

    talk.save!
    post_image = PostImage.where(post_id: talk.post.id).first
    expect(post_image).not_to be_nil
  end

  context "validate content" do
    it "is not valid without content"
    it "is not valid with content longer than 140"
  end
end
