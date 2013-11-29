require 'spec_helper'

describe Subject do
  let(:account) { create(:account) }

  context "create new subject" do
    it "is valid with valid attributes and creates a post at the same time" do
      subject = Subject.new(
                            title: "title",
                            content: "content"
                            )
      subject.creator = account
      expect(subject).to be_valid
    end

    it "should add exp" do
      exp_strategy = create(:exp_strategy_day, app_name: "exp_post_subject")
      subject = Subject.new(title: "title", content: "content")
      subject.creator = account
      subject.save!

      expect(account.exp).to eq exp_strategy.value
    end
  end

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
