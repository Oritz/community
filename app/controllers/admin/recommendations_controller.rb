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
      format.html # show.html.erb
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
       
       if @recommendation.recommend_type == Recommendation::RECOMMEND_TYPE_NORMAL
      @games = Game.find(
        :all, 
        :select =>"id,name",
        :group =>"id"
      )    
    end
      
  end

  # POST /recommendations
  # POST /recommendations.xml
  def create
    @recommendation = Recommendation.new(params[:recommendation])
    err = nil
    
    1.times do 
      if  !params[:image]
        @recommendation.errors[:base] << I18n.t("ERRORS.ERR_RECOMENDATED_IMG_NULL")
        break
      end
      
      file_type = params[:image][0].content_type.chomp
      
      if (file_type !~ /^image\/.*?jpeg|jpg|png|bmp|gif$/i)   # File type should be IMAGE
        err = I18n.t("page.message.image_type_invalid")
        return err, nil
      end
      
      @recommendation.save
      
      image = params[:image][0]
      @picture = Picture.new(@recommendation,image)
      @recommendation.full_pic = @picture.url
      @picture.save
    end
    
    respond_to do |format|
      if @recommendation.errors.size == 0 && @recommendation.save!
        format.html { redirect_to(admin_recommendation_path(@recommendation), :notice => I18n.t("page.admin.release_success")) }
        format.xml  { render :xml => @recommendation, :status => :created, :location => @recommendation }
      else
        
        format.html { redirect_to :action => "new", :recommendation_type => @recommendation.recommend_type, :errors => @recommendation.errors[:base]}
        format.xml  { render :xml => @recommendation.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /recommendations/1
  # PUT /recommendations/1.xml
  def update
  
    @recommendation = Recommendation.find(params[:id])
  
    if params[:image] != nil
      image = params[:image]
      @picture = Picture.new(@recommendation,image)
      @picture.save
    end
    
    respond_to do |format|
      if @recommendation.update_attributes(params[:recommendation])
        format.html { redirect_to(admin_recommendation_path(@recommendation), :notice => 'Recommendation was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @recommendation.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /recommendations/1
  # DELETE /recommendations/1.xml
  def destroy
    @recommendation = Recommendation.find(params[:id])
    @recommendation.picture.delete
    @recommendation.destroy

    respond_to do |format|
      format.html { redirect_to(admin_recommendations_url) }
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
