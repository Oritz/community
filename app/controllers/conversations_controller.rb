class ConversationsController < ApplicationController
  before_filter :sonkwo_authenticate_account
  #layout "home"

  def index
    @private_messages = PrivateMessage.conversations(current_account).paginate(page: params[:page], per_page: 10)
    current_account.notification.reset(:private_message)
  end

  def show
    @conversation = Conversation.find(params[:id])
    return unless check_access?(conversation: @conversation)

    @recipient = @conversation.first_account == current_account ? @conversation.second_account : @conversation.first_account
    @private_messages = PrivateMessage.conversation_detail(@conversation, current_account).paginate(page: params[:page], per_page: 10)
    PrivateMessage.read(@conversation, current_account)
  end

  def destroy
    @conversation = Conversation.find(params[:id])
    return unless check_access?(conversation: @conversation)

    PrivateMessage.conversation_destroy(@conversation, current_account)

    respond_to do |format|
      format.html { redirect_to :back }
    end
  end
end
