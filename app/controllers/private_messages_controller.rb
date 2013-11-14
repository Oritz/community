class PrivateMessagesController < ApplicationController
  before_filter :sonkwo_authenticate_account
  layout "home"

  def create
    @private_message = PrivateMessage.new(params[:private_message])
    @recipient = Account.find(params[:recipient_id])
    @private_message.sender = current_account
    @private_message.recipient = @recipient

    respond_to do |format|
      if @private_message.save
        format.html { redirect_to :back }
        format.json { render_for_api :show, json: @private_message, root: "data", meta: {status: "success"} }
      else
        format.json { render json: {status: "fail", data: @private_message.errors} }
        format.html { redirect_to :back }
      end
    end
  end

  def destroy
    @private_message = PrivateMessage.find(params[:id])
    return unless check_access?(private_message: @private_message)

    if @private_message.conversation.first_account == current_account
      @private_message.first_deleted_at = Time.now
    elsif @private_message.conversation.second_account == current_account
      @private_message.second_deleted_at = Time.now
    else
      respond_to do |format|
        format.html { redirect_to :back, flash: {error: I18n.t("private_message.delete.denied")} }
        format.json { render json: {status: "error", message: I18n.t("private_message.delete.denied")} }
      end
      return
    end

    respond_to do |format|
      if @private_message.save
        format.html { redirect_to :back }
        format.json { render json: {status: "success", data: nil} }
      else
        format.html { redirect_to :back, flash: {error: @private_message.full_messages} }
        format.json { render json: {status: "fail", data: @private_message.errors} }
      end
    end
  end
end
