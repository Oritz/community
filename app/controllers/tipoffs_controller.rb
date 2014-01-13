class TipoffsController < ApplicationController
  before_filter :sonkwo_authenticate_account
  layout false

  def create
    reason = TipoffReason.find(params[:tipoff_reason_id])

    if tipoff = current_account.tip_off(params[:detail_type], params[:detail_id], reason)
      if tipoff.errors.empty?
        message = {channel: "/notifications/#{tipoff.target.id}", data: {id: tipoff.id}}
        uri = URI.parse("http://localhost:9292/notifications")
        Net::HTTP.post_form(uri, message: message.to_json)
        render json: { status: "success", data: { id: tipoff.id } }
      else
        render json: { status: "fail", data: tipoff.errors }
      end
    else
      render json: { status: "error", message: I18n.t("account.tipoff_failed") }
    end
  end
end
