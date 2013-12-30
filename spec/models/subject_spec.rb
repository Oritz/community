require 'spec_helper'

describe Subject do
  let(:account) { create(:account) }
  let!(:exp_strategy) { create(:exp_strategy_day, app_name: "exp_post_subject") }

  context "create new subject" do
    it "is valid with valid attributes and creates a post at the same time" do
      subject = Subject.new(
                            title: "title",
                            content: "content",
                            main_body: "main body"
                            )
      subject.creator = account
      expect(subject).to be_valid
      expect { subject.save! }.to change { account.exp }.by(exp_strategy.value)
      expect(Post.first).to eq subject.post
    end

    it "should create a new pending subject" do
      subject = Subject.new
      subject.creator = account
      subject.status = Post::STATUS_PENDING

      expect(subject).to be_valid
      expect { subject.save! }.to change { account.exp }.by(0)
    end

    it "should update a new subject" do
      subject = Subject.new(title: "title", content: "content", main_body: "main body")
      subject.creator = account
      subject.save!

      subject.content = "content1"
      subject.main_body = "main body1"
      expect { subject.save! }.not_to change { account.exp }.by(exp_strategy.value)
    end

    it "should not re-create a new pending subject" do
      subject = Subject.new
      subject.creator = account
      subject.status = Post::STATUS_PENDING
      subject.save!

      subject = Subject.new
      subject.creator = account
      subject.status = Post::STATUS_PENDING
      expect(subject).not_to be_valid
    end
  end

  context "post_pending" do
    it "should post a subject using post_pending" do
      subject = Subject.new
      subject.creator = account
      subject.status = Post::STATUS_PENDING
      subject.save!

      subject.content = "content"
      subject.title = "title"
      subject.main_body = "main body"
      expect(subject.post_pending).to eq true
      expect(subject.status).to eq Post::STATUS_NORMAL
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
end
