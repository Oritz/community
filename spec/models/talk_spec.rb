require 'spec_helper'

describe Talk do
  let(:account) { create(:account) }
  let(:cloud_storage) { create(:cloud_storage) }

  it "is valid with valid attributes and creates post at the same time"

  it "should create a new item without image_url" do
    talk = Talk.new(content: "content")
    talk.creator = account

    expect { talk.save! }.not_to raise_error
  end

  it "should create a new item with cloud_storage_id" do
    talk = Talk.new(content: "content", cloud_storage_id: cloud_storage.id)
    talk.creator = account
    talk.save!

    post_image = PostImage.where(post_id: talk.id).first
    expect(post_image).not_to be_nil
  end

  it "should create post_image while fill image_url" do
    url = "http://bucket_name.u.qiniudn.com/key"
    talk = Talk.new(content: "content", image_url: url)
    talk.creator = account

    talk.save!
    post_image = PostImage.where(post_id: talk.id).first
    expect(post_image).not_to be_nil
  end

  context "validate content" do
    it "is not valid without content"
    it "is not valid with content longer than 140"
  end
end
