require 'spec_helper'

describe Album do
  let(:account) { create(:account) }

  it "is valid with valid attributes" do
    album = Album.new(name: "album1")
    album.account = account
    expect(album).to be_valid
  end

  context "TODO"
end
