require 'spec_helper'

describe Account do
  it 'should has a valid factory' do
    create(:account).should be_valid
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

  end

  it 'should invalid without a password' do
    build(:account, password: nil).should_not be_valid
  end

  it 'should have a password with 8..128 length' do
    too_short_password = "1234567"
    least_password = "12345678"
    too_long_password = "0123456789" * 12 + "012345678"
    longest_password = "0123456789" * 12 + "12345678"
    build(:account, password: too_short_password).should_not be_valid
    build(:account, password: too_long_password).should_not be_valid
    build(:account, password: least_password).should be_valid
    build(:account, password: longest_password).should be_valid
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
end
