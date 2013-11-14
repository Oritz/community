require 'spec_helper'

describe Subject do
  it "is valid with valid attributes and creates post at the same time"

  context "validate content" do
    it "is not valid without content"
  end

  context "validate title" do
    it "is not valid without title"
    it "is not valid with title longer than 64"
  end

  context "with group" do
    it "should be sorted by time"
    it "should be sorted by like count"
    it "should be sorted by comment count"
    it "should be sorted by created time"
  end
end
