require 'spec_helper'

describe PrivateMessage do
  let(:conversation) { create(:conversation) }

  it "is valid with valid attributes" do
    pm = PrivateMessage.new(content: "content")
    pm.conversation = conversation
    expect(pm).to be_valid
  end
end
