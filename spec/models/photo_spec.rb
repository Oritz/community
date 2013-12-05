require 'spec_helper'

describe Photo do
  let(:account) { create(:account) }
  let(:album) { create(:album, account: account) }
  let(:cloud_storage_image) { create(:cloud_storage_image, account: account) }

  it "is valid with valid attributes" do
    photo = Photo.new(description: "photo")
    photo.album = album
    photo.account = account
    photo.cloud_storage = cloud_storage_image
    expect(photo).to be_valid
  end

  context "TODO"
end
