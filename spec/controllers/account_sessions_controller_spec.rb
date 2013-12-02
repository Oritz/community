require 'spec_helper'

describe AccountSessionsController do
  let(:account) { create(:account) }

  describe "POST create" do
    it "should create a new session" do
      pending "test cookies"
      expect(subject.current_account).not_to be_nil
    end

    it "should create a new session with json" do
    end
  end

  describe "DELETE destroy" do
    it "deletes a session" do
      delete :destroy
      expect(subject.current_account).to be_nil
    end
  end
end
