class TalksController < ApplicationController
  before_filter :sonkwo_authenticate_account, only: [:create]

  def show
    # Show the content of a post and comments
    @talk = Talk.find(params[:id])

    respond_to do |format|
      format.html # show.html.slim
      format.json { render json: @talk }
    end
  end

  def create
    @talk = Talk.new(params[:talk])
    @talk.creator = current_account

    respond_to do |format|
      if @talk.save
        format.html { redirect_to @talk.post, notice: 'Talk was successfully created.' }
        format.json { render_for_api :post_info, json: @talk, root: "data", meta: {status: "success"} }
      else
        format.html { raise "TODO:" } #TODO:
        format.json { render json: { status: "fail", data: @talk.errors } }
      end
    end
  end
end
