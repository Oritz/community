# -*- encoding : utf-8 -*-
require 'common/picture'
class Admin::RecommendationsController < AdminController
  def index
    @actived_type = params[:recommend_type] || Recommendation::RECOMMEND_TYPE_TOP
    @top_recommendations = Recommendation.in_type(Recommendation::RECOMMEND_TYPE_TOP)
    @normal_recommendations = Recommendation.in_type(Recommendation::RECOMMEND_TYPE_NORMAL).includes(:game)
    @normal_recommendations = Recommendation.select('recommendations.id, games.title, recommend_type, recommendations.link').joins(:game).all
    @focus_recommendations = Recommendation.in_type(Recommendation::RECOMMEND_TYPE_FOCUS)
    respond_to do |format|
      format.html # index.html.slim
      format.xml  { render :xml =>@top_recommendations}#待修改
    end
  end

  # GET /recommendations/1
  # GET /recommendations/1.xml
  def show
  @recommendation = Recommendation.find(params[:id])

    respond_to do |format|
      format.html # show.html.slim
      format.xml  { render :xml => @recommendation }
    end
  end

  # GET /recommendations/new
  # GET /recommendations/new.xml
  def new
    @require_type = params[:recommendation_type]
    @recommendation = Recommendation.new
    @games = Game.select('id, title').all

    respond_to do |format|
      format.html # new.html.slim
      format.xml  { render :xml => @recommendation }
    end
  end

  # GET /recommendations/1/edit
  def edit
    @recommendation = Recommendation.find(params[:id])
    @games = Game.select('id, title') if @recommendation.recommend_type == Recommendation::RECOMMEND_TYPE_NORMAL
      
  end

  # POST /recommendations
  # POST /recommendations.xml
  def create
    @recommendation = Recommendation.new(params[:recommendation])
    #explict assign or it will not call method pictrue= when picture is not choosen
    @recommendation.picture = params[:recommendation][:picture]

    respond_to do |format|
      if @recommendation.errors.empty? && @recommendation.save!
        format.html { redirect_to(admin_recommendations_path(:recommend_type => @recommendation.recommend_type), :notice => t('admin.msg.success')) }
      else
        flash[:alert] = @recommendation.errors[:base]
        format.html { redirect_to :action => "new", :recommendation_type => @recommendation.recommend_type}
      end
    end
  end

  # PUT /recommendations/1
  # PUT /recommendations/1.xml
  def update
    @recommendation = Recommendation.find(params[:id])
    #explict assign to validate the pic format
    @recommendation.picture = params[:recommendation][:picture] if params[:recommendation][:picture]
    respond_to do |format|
      if @recommendation.errors.empty? && @recommendation.update_attributes!(params[:recommendation])
        format.html { redirect_to(admin_recommendations_path(:recommend_type => @recommendation.recommend_type), :notice => t('admin.msg.success')) }
      else
        flash[:alert] = @recommendation.errors[:base]
        format.html { render :action => "edit" }
      end
    end
  end

  # DELETE /recommendations/1
  # DELETE /recommendations/1.xml
  def destroy
    @recommendation = Recommendation.find(params[:id])
    @recommendation.destroy

    respond_to do |format|
      format.html { redirect_to(admin_recommendations_url(:recommend_type => @recommendation.recommend_type)) }
      format.xml  { head :ok }
    end
  end


private
  def validate_idt
    err = AdminController.validate_identity(session[:admin_identity], Role::ID_EDIT_RECOMMENDATION)
    unless  err == nil
      render(:text => err)
    end
  end
end
