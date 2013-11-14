require 'spec_helper'

describe Group do
  let(:creator) { create(:account) }

  it "is valid with valid attributes" do
    group = Group.new(
                      name: "group1",
                      description: "group desc"
                      )
    group.creator = creator
    expect(group).to be_valid
  end

  context "validate name" do
    it "is not valid without name" do
      group = Group.new(
                        name: nil,
                        description: "desc"
                        )
      group.creator = creator
      expect(group).not_to be_valid
    end

    it "is not valid with name longer than 31" do
      group = Group.new(
                        name: "12345678901234567890123456789012",
                        description: "desc"
                        )
      group.creator = creator
      expect(group).not_to be_valid
    end
  end

  context "validate description" do
    it "is not valid without descriptions" do
      group = Group.new(
                        name: "group1",
                        description: nil
                        )
      group.creator = creator
      expect(group).not_to be_valid
    end

    it "is not valid with name longger than 255" do
      description = "s" * 256
      group = Group.new(
                        name: "group1",
                        description: description
                        )
      group.creator = creator
      expect(group).not_to be_valid
    end
  end

  context "validate creator" do
    it "is not valid without creator" do
      group = Group.new(
                        name: "group1",
                        description: "desc"
                        )
      group.creator = nil
      expect(group).not_to be_valid
    end
  end

  context "with accounts" do
    let(:group) { create(:group, creator: creator) }
    let(:newer) { create(:account) }

    it "should be added by a user" do
      expect { group.accounts << newer }.to change { group.accounts.count }.from(1).to(2)
    end

    it "should be quited by a user" do
      group.accounts << newer
      expect { group.accounts.delete newer }.to change { group.accounts.count }.from(2).to(1)
    end
  end

  it "should be sort by hot" do
    groups = create_list(:group, 25)
    groups.each_with_index do |g, index|
      g.member_count = index + 2
      g.save
    end

    expect(Group.sort_by_hot(5)).to eq(groups.reverse[0..4])
  end

  it "should show newcomers" do
    group = create(:group)
    accounts = create_list(:account, 10)

    now = Time.now
    accounts.each_with_index do |a, index|
      Timecop.freeze(now + 1000 * index)
      group.accounts << a
      Timecop.return
    end
    expect(group.newcomers(10)).to eq(accounts.reverse)
  end

  it "should add tags"
end
