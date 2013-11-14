class Api::ClientErrorsController < ApplicationController
  before_filter :sonkwo_authenticate_account

  def create
    client_error = ClientError.new
    client_error.account = current_account
    client_error.err_msg = params[:err_msg]

    if client_error.save
      render json: { status: 'success', data: [] }
    else
      render json: { status: 'fail', data: client_error.errors.full_messages }
    end
  end
end
