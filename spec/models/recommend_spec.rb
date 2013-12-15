require 'spec_helper'

describe Recommend do
  let(:account) { create(:account) }
  let(:talk) { create(:talk, creator: account) }

  it "should create a recommend post" do
    recommend = Recommend.new(content: "content")
    recommend.creator = account
    recommend.original = talk.post
    recommend.parent = talk.post
    recommend.original_author = talk.creator

    expect(recommend).to be_valid
    expect { recommend.save! }.to change{Post.count}.by(1)
  end

  context "other tests"
end
