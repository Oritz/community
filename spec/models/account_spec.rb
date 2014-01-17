require 'spec_helper'

describe Account do
  it 'should has a valid factory' do
    build(:account).should be_valid
  end

  it 'should invalid without a email' do
    build(:account, email: nil).should_not be_valid
    build(:account).should be_valid
  end

  it 'should invalid without a email' do
    build(:account, email: nil).should_not be_valid
  end

  it "should with a correct format email" do
    valid_emails = ["valid@gmail.com", "234234123@qq.com", "someemail@126.com", "someemail@sina.com",
                    "someemail@foxmail.com", "someemail@163.com", "someemail@live.com"]

    invalid_emails = ["rex", "test@go,com", "test user@example.com", "test_user@example server.com", "test@gmail.11"]

    valid_emails.each do |e|
      build(:account, email: e).should be_valid
    end

    invalid_emails.each do |i|
      build(:account, email: i).should_not be_valid
    end

    invalid_emails.each do |i|
      build(:account, email: i).should_not be_valid
    end

  end

  it 'should invalid without a password' do
    build(:account, password: nil).should_not be_valid
  end

  it 'should have a password with 8..128 length' do
    too_short_password = "1234567"
    least_password = "12345678"
    too_long_password = "0123456789" * 12 + "012345678"
    longest_password = "0123456789" * 12 + "12345678"
    build(:account, password: too_short_password, password_confirmation: too_short_password).should_not be_valid
    build(:account, password: too_long_password, password_confirmation: too_long_password).should_not be_valid
    build(:account, password: least_password, password_confirmation: least_password).should be_valid
    build(:account, password: longest_password, password_confirmation: longest_password).should be_valid
  end

  it 'should support characters within a password' do
   # Factory.build(:account, password: "123pass!@#$%^&*").should be_valid
  end

  it 'should invalid withou a password comfirmation' do
    build(:account, password_confirmation: nil).should_not be_valid
  end

  it 'should invalid when password not equal password confirmation' do
    build(:account, password: '12345678', password_confirmation: '87654321').should_not be_valid
  end

  it 'should support characters within a password' do
    # build(:account, password: "123pass!@#$%^&*").should be_valid
  end

  it 'should invalid withou a password comfirmation' do
    build(:account, password_confirmation: nil).should_not be_valid
  end

  it 'should invalid when password not equal password confirmation' do
    build(:account, password: '12345678', password_confirmation: '87654321').should_not be_valid
  end

  it "should create the screenshot album" do
    account = build(:account)
    account.save
    album = Album.screenshot_of_account(account)
    expect(album).not_to be_nil
  end

  context "validate email" do
    it "is not valid without email" do
      account = build(:account)
      account.email = nil
      expect(account).not_to be_valid
    end

    it "is not valid with email invalid" do
      account = build(:account)
      account.email = "asdf"
      expect(account).not_to be_valid
    end
  end

  context "validate nick_name" do
    it "is not valid without nick_name" do
      account = build(:account)
      account.nick_name = ""
      expect(account).not_to be_valid
    end

    it "is not valid with nick_name longer than 30" do
      account = build(:account)
      account.nick_name = "s" * 31
      expect(account).not_to be_valid
    end

    it "is not valid with nick_name shorter than 2" do
      account = build(:account)
      account.nick_name = "s"
      expect(account).not_to be_valid
    end

    it "is not valid with nick_name repeated" do
      account = create(:account)
      new_account = build(:account)
      new_account.nick_name = account.nick_name
      expect(new_account).not_to be_valid
    end
  end

  it "should change_password" do
    password = "12345678"
    new_password = "asdfasdf"
    account = create(:account, password: password)
    expect(account.change_password({
                                   old_password: password,
                                   password: new_password,
                                   password_confiramton: new_password
                                   })).to be_true
  end

  context "social actions" do
    let(:account) { create(:account) }

    it "should recommend a post" do
      post = create(:post)
      recommend = account.recommend(post, "recommend reason")
      expect(post.recommend_count).to eq 1
      expect(account.recommend_count).to eq 1
      expect(recommend[0]).to eq true
    end

    it "should raise an error if text is more than 140" do
      post = create(:post)
      recommend = account.recommend(post, "s"*141)
      expect(recommend[0]).to eq false
    end
  end

  context "tip-off" do
    let(:account) { create(:account) }
    let(:reason) { create(:tipoff_reason) }

    it "should tip-off a group" do
      group = create(:group)
      expect(account.tip_off("Group", group.id, reason)).not_to be_nil

      tipoff = Tipoff.first
      expect(tipoff).not_to be_nil
    end

    it "should tip-off a post" do
      post = create(:post)
      expect(account.tip_off("Post", post.id, reason)).not_to be_nil

      tipoff = Tipoff.first
      expect(tipoff).not_to be_nil
    end

    it "should tip-off an account" do
      another = create(:account)
      expect(account.tip_off("Account", account.id, reason)).not_to be_nil

      tipoff = Tipoff.first
      expect(tipoff).not_to be_nil
    end
  end
end
