require 'spec_helper'

describe CloudStorage do
  let(:account) { create(:account) }

  it "should create an item with url" do
    url = "http://bucket_name.qiniudn.com/key"
    cloud_storage = CloudStorage.new(url: url)
    expect(cloud_storage.bucket_name).to eq "bucket_name"
    expect(cloud_storage.key).to eq "key"
  end
end
