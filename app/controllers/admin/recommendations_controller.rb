# -*- encoding : utf-8 -*-
class Admin::RecommendationsController < ApplicationController
  def index
  
    @actived_type = params[:recommend_type] || 0
    @top_recommendations = Recommendation.select('id, link, recommend_type').where('recommend_type=?', Recommendation::RECOMMEND_TYPE_TOP).all

    @normal_recommendations = Recommendation.find(
      :all,
      :select =>"rd.id, rd.link, name,recommend_type",
      :joins =>"AS rd INNER JOIN games ON rd.link=games.id",
      :group =>"games.id",
      :conditions =>["recommend_type=?", Recommendation::RECOMMEND_TYPE_NORMAL]
    )

    @normal_recommendations = Recommendation.select('id, link, recommend_type').includes(:game).where('recommend_type=?', Recommendation::RECOMMEND_TYPE_NORMAL).all

    @focus_recommendations = Recommendation.find(
      :all,
      :select =>"id, link, recommend_type",
      :conditions =>["recommend_type=?", Recommendation::RECOMMEND_TYPE_FOCUS]
    )
    
    respond_to do |format|
      format.html # index.html.erb
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
    @games = Game.select('id, name').all
    
    respond_to do |format|
      format.html # new.html.erb
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
 
  #  @link = params[:recommendation][:link]
  #  @type_id = params[:recommendation][:game_type_id]
  #  @recommend_type = params[:recommendation][:recommend_type]
  #  @weight = params[:weight]
  #  @recommendation = Recommendation.new(
  #    :link => @link,
  #    :recommend_type => @recommend_type,
  #    :sub_type => @type_id,
  #    :weight => @weight
  #  )
    
    @recommendation = Recommendation.new(params[:recommendation])
    
    #Top_pic
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
