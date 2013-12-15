require 'spec_helper'

describe PostImage do
  let(:account) { create(:account) }
  let(:talk) { talk = Talk.new(content: "content"); talk.creator = account; talk.save!; talk }
  let(:post) { talk.post}
  let(:cloud_storage) { create(:cloud_storage_image, account: account) }

  it "is valid using valid attributes" do
    post_image = PostImage.new(comment: "comment")
    post_image.post = post
    post_image.cloud_storage = cloud_storage
    expect(post).to be_valid
  end

  it "should using url first if url and cloud_storage coexist" do
    url = cloud_storage.url + "1"
    post_image = PostImage.new(url: url, comment: "comment")
    post_image.post = post
    post_image.cloud_storage = cloud_storage
    post_image.save!

    expect(post_image.cloud_storage.id).not_to eq cloud_storage.id
  end

  it "should create cloud_storage while filling url" do
    url = "http://bucket_name.u.qiniudn.com/key"
    post_image = PostImage.new(url: url, comment: "comment")
    post_image.post = post
    post_image.save!

    cloud_storage = CloudStorage.find(post_image.cloud_storage.id)
    expect(cloud_storage).not_to be_nil
  end

  it "should create a new cloud_storage while using a new url" do
    post_image = PostImage.new
    post_image.post = post
    post_image.cloud_storage = cloud_storage

    url = "http://bucket_name.u.qiniudn.com/using_in_post_image"
    post_image.url = url
    post_image.save!

    expect(post_image.cloud_storage.id).not_to eq cloud_storage.id
  end

  it "is not valid if create more than one images with talk" do
    talk = Talk.new(content: "content", cloud_storage_id: cloud_storage.id)
    talk.creator = account
    talk.save!

    post_image = PostImage.new
    post_image.post = talk.post
    post_image.cloud_storage = create(:cloud_storage)

    post_image.valid?

    expect(post_image).not_to be_valid
  end
end
