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
    if params[:group_id]
      @group = Group.find(params[:group_id])
      @talk.group = @group
    end

    respond_to do |format|
      if @talk.save
        @talk.post.detail = @talk
        format.html { redirect_to @talk.post, notice: 'Talk was successfully created.' }
        format.json
      else
        format.html { raise "TODO:" } #TODO:
        format.json { render json: { status: "fail", data: @talk.errors } }
      end
    end
  end
end
