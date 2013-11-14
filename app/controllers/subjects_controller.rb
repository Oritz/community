class SubjectsController < ApplicationController
  before_filter :sonkwo_authenticate_account, only: [:create]
  layout "home"

  def show
    # Show the content of a post and comments
    @subject = Subject.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @subject }
    end
  end

  def new
    @subject = Subject.new
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
    @subject = Subject.new(params[:subject])
    @subject.creator = current_account
    if params[:group_id]
      @group = Group.find(params[:group_id])
      @subject.group = @group
    end

    respond_to do |format|
      if @subject.save
        format.html { redirect_to @subject.post, notice: 'Subject war successfully created.' }
        format.json { render json: @subject, status: :created, location: @subject }
      else
        format.html { raise "TODO:" } #TODO: 
        format.json { raise "TODO:" } #TODO:
      end
    end
  end

  def edit
    @subject = Subject.find(params[:id])
    return unless check_access?(auth_item: "oper_subjects_update", subject: @subject)
  end

  def update
    @subject = Subject.find(params[:id])
    return unless check_access?(subject: @subject)

    respond_to do |format|
      if @subject.update_attributes(params[:subject])
        format.html { redirect_to @subject.post, notice: 'Subject was successfully updated.'}
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @subject.errors, status: :unprocessable_entity }
      end
    end
  end
end
