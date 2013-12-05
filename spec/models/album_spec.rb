require 'spec_helper'

describe Album do
  let(:account) { create(:account) }

  it "is valid with valid attributes" do
    album = Album.new(name: "album1")
    album.account = account
    expect(album).to be_valid
  end

  it "is not valid with more than one screenshot album" do
    album = Album.new(name: "album1")
    album.account = account
    album.album_type = Album::TYPE_SCREENSHOT
    expect(album).not_to be_valid
  end

  context "TODO"
end
