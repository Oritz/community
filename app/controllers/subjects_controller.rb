class SubjectsController < ApplicationController
  before_filter :sonkwo_authenticate_account, only: [:create, :new, :update]

  def show
    # Show the content of a post and comments
    @subject = Subject.find(params[:id])
    
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @subject }
    end
  end

  def new
    @subject = current_account.pending_subject
    @cloud_storage_settings = CloudStorage.settings(current_account)
    if params[:group_id]
      @group = Group.find(params[:group_id])
      @subject.group = @group
    end

    respond_to do |format|
      format.html
      format.json { render json: @group }
    end
  end

  def create
    @subject = current_account.pending_subject
    if params[:group_id]
      @group = Group.find(params[:group_id])
      @subject.group = @group
    end

    respond_to do |format|
      if @subject.post_pending
        format.html { redirect_to @subject.post, notice: 'Subject was successfully created.' }
        format.json { render json: @subject, status: :created, location: @subject }
      else
        format.html { redirect_to :new } #TODO: 
        format.json { raise "TODO:" } #TODO:
      end
    end
  end

  def edit
    @subject = Subject.find(params[:id])
    return unless check_access?(auth_item: "oper_subjects_update", subject: @subject)
  end

  def update
    @subject = Subject.includes([post: [:post_images]]).find(params[:id])
    #return unless check_access?(subject: @subject)

    respond_to do |format|
      if @subject.update_attributes(params[:subject])
        format.html { redirect_to @subject.post, notice: 'Subject was successfully updated.'}
        format.json { render_for_api :preview, json: @subject, root: "data", meta: {status: "success"} }
      else
        format.html { render action: "edit" }
        format.json { render json: @subject.errors, status: :unprocessable_entity }
      end
    end
  end
end