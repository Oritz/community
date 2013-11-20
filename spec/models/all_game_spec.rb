require 'spec_helper'

describe AllGame do
  it "is valid with valid attributes" do
    game = AllGame.new(name: "testname")
    expect(game).to be_valid
  end

  context "validate name" do
    it "is not valid without name" do
      game = AllGame.new
      expect(game).not_to be_valid
    end

    it "is not valid with name longer than 255" do
      name = "s" * 256
      game = AllGame.new(name: name)
      expect(game).not_to be_valid
    end
  end
end
