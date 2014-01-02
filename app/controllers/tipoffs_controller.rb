class TipoffsController < ApplicationController
  before_filter :sonkwo_authenticate_account
  layout false

  def create
    reason = Tipoff.find(params[:tipoff_reason_id])
    if params[:group_id]
      item = Group.find(params[:group_id])
    elsif params[:post_id]
      item = Post.find(params[:post_id])
    elsif params[:account_id]
      item = Account.find(params[:account_id])
    else
      not_found
    end

    if tipoff = current_account.tip_off(item, reason)
      render json: { status: "success", data: { id: tipoff.id } }
    else
      render json: { status: "error", message: I18n.t("account.tipoff_failed") }
    end
  end
end
