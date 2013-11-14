require 'spec_helper'

describe ConversationsController do
  login_account

  describe "GET index" do
    it "should list conversations of a certain user" do
      pending "to be done"
      get :index
    end
  end

  describe "GET show" do
    let(:recipient) { create(:account) }
    let(:conversation) { create(:conversation, first_account: controller.current_account, second_account: recipient) }

    it "should show error message if the user is not the participent of a conversation"

    it "should show details of a conversation" do
      private_messages = build_list(:private_message, 25, conversation: conversation)
      now = Time.now
      private_messages.each_with_index do |pm, index|
        pm.sender = pm.conversation.first_account
        pm.recipient = pm.conversation.second_account
        Timecop.freeze(now + 1000 * index)
        pm.save!
        Timecop.return
      end

      get :show, id: conversation.id
      expect(assigns(:private_messages)).to eq private_messages.reverse[0..9]
    end
  end

  describe "DELETE destroy" do
    it "should delete a conversation"
  end
end
