# -*- encoding : utf-8 -*-
require 'uuidtools'
class Admin::GamesController < AdminController
  def index
    query = params[:query] ? params[:query].lstrip.rstrip : nil
    auditing_games = nil
    page = params[:page] || 1

    if query == "" || query == nil
      @games = Game.all
    else
      @games = Game.paginate(
          :conditions => "name LIKE '%#{query}%' OR english_name LIKE '%#{query}%'",
          :page => params[:page],
          :per_page =>10
      )
    end

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @admin_games }
    end
  end

  # GET /admin_games/1
  # GET /admin_games/1.xml
  def show
    @game = Game.find(
        :all,
        :select => "games.id AS id, ext_id, name, ext_platform",
        :joins => "LEFT JOIN game_ext_ids ON games.id = game_ext_ids.game_id",
        :conditions => ["games.id =?", params[:id]]
    )

    @ext_servers = YAML.load_file("#{Rails.root}/config/app_data/ext_platforms.yml")

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @game }
    end
  end

  # GET /admin_games/new
  # GET /admin_games/new.xml
  def new
    @game = Game.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @game }
    end
  end

  # GET /admin_games/1/edit
  def edit
    @game = Game.find(params[:id])
  end

  # POST /admin_games
  # POST /admin_games.xml
  def create
    @game = Game.new(params[:game])

    respond_to do |format|
      if @game.save
        format.html { redirect_to(@game, :notice => 'Admin::Game was successfully created.') }
        format.xml  { render :xml => @game, :status => :created, :location => @game }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @game.errors, :status => :unprocessable_entity }
      end
    end
  end


  # PUT /admin_games/1.xml
  def update
    @game = Game.find(params[:id])

    respond_to do |format|
      if @game.update_attributes(params[:game])
        format.html { redirect_to(@game, :notice => 'Admin::Game was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @game.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /admin_games/1
  # DELETE /admin_games/1.xml
  def destroy
    @game = Game.find(params[:id])
    @game.destroy

    respond_to do |format|
      format.html { redirect_to(admin_games_url) }
      format.xml  { head :ok }
    end
  end



  # 按名字查找游戏
  def search
    @admin_games = Game.paginate(
        :page => params[:page],
        :per_page =>10,
        :conditions => ["name like ?", "%"+params[:query]+"%"]
    )

    render :index
  end


  # 管理成就
  def manage_achievement
    game_id = params[:id]

    begin
      ActiveRecord::Base.transaction do
        @achievements = GameAchievement.find(
            :all,
            :select =>"game_id,achievement_name,title,description,icon,icon_locked",
            :conditions => ["game_id=?", game_id]
        )
      end
    rescue
      puts $!.inspect
      puts $!.backtrace
    end

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @achievements }
    end
  end



  # => 设置外部关联
  def external_info
    ext_server_name = params[:admin_game_ext_id][:ext_platform]
    game_id = params[:admin_game_ext_id][:game_id]

    @game = Game.find(
        :first,
        :select => "id, english_name, name",
        :conditions => ["id = ?", game_id]
    )

    @exit_ext = Admin::GameExtId.find(
        :first,
        :conditions => ["game_id = ? AND ext_platform = ?", game_id, ext_server_name]
    )

    unless @exit_ext
      @exit_ext = Admin::GameExtId.new(
          :game_id => game_id,
          :ext_platform => ext_server_name
      )
    end

    if !request.get?
      ext_id = params[:admin_game_ext_id][:ext_id]

      begin
        if ext_id && ext_id != ""
          @exit_ext.update_attributes(params[:admin_game_ext_id])
        else
          @exit_ext.destroy if @exit_ext
        end

        redirect_to( {:action =>"show", :id => game_id, :notice => '操作成功'})
      rescue
        puts $!.inspect
        puts $!.backtrace
      end
    end
  end

  def modify_home_page
    begin
      @game_id = params[:game_id].to_i

      template_dir = "#{Rails.root}/app/views/game_home_page"
      @templates = Array.new
      Dir.foreach(template_dir) do |template|
        @templates << template if template != "." && template != ".." && File.directory?(template_dir + "/" + template)
      end

      publisher_dir = "#{Rails.root}/public/images/publisher_logos"
      @publishers = Array.new
      Dir.foreach(publisher_dir) do |publisher|
        unless File.directory?(publisher_dir + "/" + publisher)
          @publishers << {:name => File.basename(publisher, File.extname(publisher)),
                          :url => "/images/publisher_logos/#{File.basename(publisher)}"}
        end
      end

      developer_dir = "#{Rails.root}/public/images/developer_logos"
      @developers = Array.new
      Dir.foreach(developer_dir) do |developer|
        unless File.directory?(developer_dir + "/" + developer)
          @developers << {:name => File.basename(developer, File.extname(developer)),
                          :url => "/images/developer_logos/#{File.basename(developer)}"}
        end
      end

      @game_home_page = GameHomePage.first(:conditions => ["game_id=?", @game_id])

      unless @game_home_page
        @game_home_page = GameHomePage.new
        @game_home_page.game_id = @game_id
        @game_home_page.logo = ""
        @game_home_page.image = ""
        @game_home_page.background_img = ""
        @game_home_page.brief = ""
        @game_home_page.publisher_logo = ""
        @game_home_page.developer_logo = ""
        @game_home_page.forum_addr = ""
        @game_home_page.title = ""
        @game_home_page.requirement = ""
        @game_home_page.template_name = "default"
      end

      if request.post?
        t = Time.now
        @game_home_page.template_name = params[:game_home_page][:template_name]
        #@game_home_page.logo = params[:game_home_page][:logo]
        #@game_home_page.image = params[:game_home_page][:image]
        #@game_home_page.background_img = params[:game_home_page][:background_img]
        @game_home_page.publisher_logo = params[:game_home_page][:publisher_logo]
        @game_home_page.developer_logo = params[:game_home_page][:developer_logo]
        @game_home_page.brief = params[:game_home_page][:brief]
        @game_home_page.forum_addr = params[:game_home_page][:forum_addr]
        @game_home_page.title = params[:game_home_page][:title]
        @game_home_page.requirement = params[:game_home_page][:requirement]
        @game_home_page.updated_at = t
        @game_home_page.created_at = t unless @game_home_page.id

        # save images
        if params[:game_home_page][:logo]
          ret = save_template_image(params[:game_home_page][:logo], "template", "logo", @game_id)
          @game_home_page.logo = ret[:url] if ret
        end

        if params[:game_home_page][:image]
          ret = save_template_image(params[:game_home_page][:image], "template", "image", @game_id)
          @game_home_page.image = ret[:url] if ret
        end

        if params[:game_home_page][:background_img]
          ret = save_template_image(params[:game_home_page][:background_img], "template", "bg", @game_id)
          @game_home_page.background_img = ret[:url] if ret
        end

        if params[:game_home_page][:download_background]
          ret = save_template_image(params[:game_home_page][:download_background], "template", "dlbg", @game_id)
          @game_home_page.download_background = ret[:url] if ret
        end

        @game_home_page.save!

        redirect_to "/g/#{@game_home_page.title}"
      end
    rescue
      puts $!.inspect
      puts $!.backtrace
      raise
    end
  end

  def modify_home_page_news
    begin
      @game_id = params[:game_id].to_i

      @game_home_page = GameHomePage.find(:first, :conditions => ["game_id=:game_id", {:game_id => @game_id}])
      unless @game_home_page
        render :text => "no home page"
        return
      end

      @news = GameHomeNews.paginate(:conditions => ["game_id=:game_id", {:game_id => @game_id}], :order => "created_at DESC", :per_page => 10, :page => params[:page])
    end
  end

  def modify_home_page_picture
    begin
      @game_id = params[:game_id].to_i
      @type = params[:type].to_i

      @game_home_page = GameHomePage.find(:first, :conditions => ["game_id=:game_id", {:game_id => @game_id}])
      unless @game_home_page
        render :text => "no home page"
        return
      end

      @pictures = GameHomePicture.find(:all, :order => "privilege", :conditions => ["game_id=:game_id AND picture_type=:type", {:game_id => @game_id, :type => @type}])
    end
  end

  def modify_home_page_video
    begin
      @game_id = params[:game_id].to_i

      @game_home_page = GameHomePage.find(:first, :conditions => ["game_id=:game_id", {:game_id => @game_id}])
      unless @game_home_page
        render :text => "no home page"
        return
      end

      @videos = GameHomeVideo.find(:all, :order => "privilege", :conditions => ["game_id=:game_id", {:game_id => @game_id}])
    end
  end

  def modify_home_page_download
    begin
      @game_id = params[:game_id].to_i
      @type = params[:type].to_i

      @game_home_page = GameHomePage.find(:first, :conditions => ["game_id=:game_id", {:game_id => @game_id}])
      unless @game_home_page
        render :text => "no home page"
        return
      end

      logo_dir = "#{Rails.root}/public/images/download_site_logos"
      @logos = Array.new
      Dir.foreach(logo_dir) do |logo|
        unless File.directory?(logo_dir + "/" + logo)
          @logos << {:name => File.basename(logo, File.extname(logo)),
                     :url => "/images/download_site_logos/#{File.basename(logo)}"}
        end
      end

      @downloads = GameHomeDownload.find(:all, :conditions => ["game_id=:game_id AND download_type=:type", {:game_id => @game_id, :type => @type}])
    end
  end

  def update_home_picture
    begin
      if request.post?
        game_id = params[:game_id].to_i
        picture_id = params[:picture_id].to_i
        type = params[:type]

        @game_home_picture = GameHomePicture.find(:first, :conditions => ["id=:picture_id AND game_id=:game_id", {:game_id => game_id, :picture_id => picture_id}])
        raise "no home picture" unless @game_home_picture

        if type != "privilege"
          if @game_home_picture.picture_type.to_i != params[:game_home_picture][:picture_type].to_i
            @game_home_picture.picture_type = params[:game_home_picture][:picture_type]
            max_privilege = GameHomePicture.find(:first, :select => "MAX(privilege) AS max_privilege", :conditions => ["game_id=:game_id AND picture_type=:type", {:game_id => game_id, :type => params[:game_home_picture][:picture_type]}]).max_privilege.to_i
            max_privilege = 0 unless max_privilege
            @game_home_picture.privilege = max_privilege + 1
          end
          @game_home_picture.picture_title = params[:game_home_picture][:picture_title]

          # save the picture
          if params[:game_home_picture][:picture]
            ret = save_template_image(params[:game_home_picture][:picture], "picture", "screenshot", game_id)
            raise I18n.t("page.admin.template.error.upload_failed") unless ret
            @game_home_picture.picture_url = ret[:url]
          end
          @game_home_picture.save!
        else
          position = params[:position].to_i
          if position > @game_home_picture.privilege.to_i
            ActiveRecord::Base.transaction do
              connection = ActiveRecord::Base.connection
              sql_str = "UPDATE game_home_pictures SET privilege=privilege-1 WHERE game_id=#{game_id} AND privilege>#{@game_home_picture.privilege} AND privilege<=#{position}"
              connection.execute(sql_str)
              @game_home_picture.privilege = position
              @game_home_picture.save!
            end
          elsif position < @game_home_picture.privilege.to_i
            ActiveRecord::Base.transaction do
              connection = ActiveRecord::Base.connection
              sql_str = "UPDATE game_home_pictures SET privilege=privilege+1 WHERE game_id=#{game_id} AND privilege<#{@game_home_picture.privilege} AND privilege>=#{position}"
              connection.execute(sql_str)
              @game_home_picture.privilege = position
              @game_home_picture.save!
            end
          end
        end

        if request.xhr?
          render :json => {:result => RET_SUCCESS}
        else
          redirect_to :action => :modify_home_page_picture, :game_id => game_id, :type => @game_home_picture.picture_type
        end
      end
    rescue => e
      if request.xhr?
        render :json => {:result => RET_FAILED}
      else
        render :text => e.message
      end
    end
  end

  def create_home_picture
    begin
      if request.post?
        game_id = params[:game_id].to_i
        @game_home_page = GameHomePage.find(:first, :conditions => ["game_id=:game_id", {:game_id => game_id}])
        raise "no home page" unless @game_home_page

        max_privilege = GameHomePicture.find(:first, :select => "MAX(privilege) AS max_privilege", :conditions => ["game_id=:game_id AND picture_type=:type", {:game_id => game_id, :type => params[:game_home_picture][:picture_type]}]).max_privilege.to_i
        max_privilege = 0 unless max_privilege
        @game_home_picture = GameHomePicture.new
        @game_home_picture.game_id = game_id
        @game_home_picture.picture_type = params[:game_home_picture][:picture_type]
        @game_home_picture.picture_title = params[:game_home_picture][:picture_title]
        @game_home_picture.privilege = max_privilege + 1

        # save the picture
        if params[:game_home_picture][:picture]
          ret = save_template_image(params[:game_home_picture][:picture], "picture", "screenshot", game_id)
          raise I18n.t("page.admin.template.error.upload_failed") unless ret
          @game_home_picture.picture_url = ret[:url]
        end

        @game_home_picture.save!
        redirect_to :action => :modify_home_page_picture, :game_id => game_id, :type => @game_home_picture.picture_type
      end
    rescue => e
      render :text => e.message
    end
  end

  def delete_home_picture
    begin
      if request.post?
        game_id = params[:game_id].to_i
        picture_id = params[:picture_id].to_i

        ActiveRecord::Base.transaction do
          @game_home_picture = GameHomePicture.find(:first, :conditions => ["id=:picture_id AND game_id=:game_id", {:game_id => game_id, :picture_id => picture_id}], :lock => "LOCK IN SHARE MODE")
          raise "no home news" unless @game_home_picture

          # update the privilege
          connection = ActiveRecord::Base.connection
          sql_str = "UPDATE game_home_pictures SET privilege=privilege-1 WHERE game_id=#{game_id} AND privilege>#{@game_home_picture.privilege} "
          connection.execute(sql_str)
          unless @game_home_picture.destroy
            raise
          end
        end
        render :json => {:result => RET_SUCCESS}
      end
    rescue
      render :json => {:result => RET_FAILED}
    end
  end

  def create_home_news
    begin
      if request.post?
        game_id = params[:game_id].to_i
        @game_home_page = GameHomePage.find(:first, :conditions => ["game_id=:game_id", {:game_id => game_id}])
        raise "no home page" unless @game_home_page

        @game_home_news = GameHomeNews.new
        @game_home_news.game_id = game_id
        @game_home_news.news_type = params[:game_home_news][:news_type]
        @game_home_news.news_title = params[:game_home_news][:news_title]
        @game_home_news.news_content = params[:game_home_news][:news_content]

        @game_home_news.save!
        redirect_to :action => :modify_home_page_news, :game_id => game_id
      end
    end
  end

  def update_home_news
    begin
      if request.post?
        game_id = params[:game_id].to_i
        news_id = params[:news_id].to_i

        @game_home_news = GameHomeNews.find(:first, :conditions => ["id=:news_id AND game_id=:game_id", {:game_id => game_id, :news_id => news_id}])
        raise "no home news" unless @game_home_news
        @game_home_news.news_type = params[:game_home_news][:news_type]
        @game_home_news.news_title = params[:game_home_news][:news_title]
        @game_home_news.news_content = params[:game_home_news][:news_content]

        @game_home_news.save!
        redirect_to :action => :modify_home_page_news, :game_id => game_id
      end
    end
  end

  def delete_home_news
    begin
      if request.post?
        game_id = params[:game_id].to_i
        news_id = params[:news_id].to_i

        @game_home_news = GameHomeNews.find(:first, :conditions => ["id=:news_id AND game_id=:game_id", {:game_id => game_id, :news_id => news_id}])
        raise "no home news" unless @game_home_news

        unless @game_home_news.destroy
          raise
        end
        render :json => {:result => RET_SUCCESS}
      end
    rescue
      render :json => {:result => RET_FAILED}
    end
  end

  def create_home_download
    begin
      if request.post?
        game_id = params[:game_id].to_i
        @game_home_page = GameHomePage.find(:first, :conditions => ["game_id=:game_id", {:game_id => game_id}])
        raise "no home page" unless @game_home_page

        @game_home_download = GameHomeDownload.new
        @game_home_download.game_id = game_id
        @game_home_download.download_type = params[:game_home_download][:download_type]
        @game_home_download.title = params[:game_home_download][:title]
        @game_home_download.url = params[:game_home_download][:url]
        @game_home_download.download_site_logo = params[:game_home_download][:download_site_logo]

        @game_home_download.save!
        redirect_to :action => :modify_home_page_download, :game_id => game_id, :type => @game_home_download.download_type
      end
    rescue
      render :text => "failed"
    end
  end

  def update_home_download
    begin
      if request.post?
        game_id = params[:game_id].to_i
        download_id = params[:download_id].to_i

        @game_home_download = GameHomeDownload.find(:first, :conditions => ["id=:download_id AND game_id=:game_id", {:game_id => game_id, :download_id => download_id}])
        raise "no home download" unless @game_home_download
        @game_home_download.download_type = params[:game_home_download][:download_type]
        @game_home_download.title = params[:game_home_download][:title]
        @game_home_download.url = params[:game_home_download][:url]
        @game_home_download.download_site_logo = params[:game_home_download][:download_site_logo]

        @game_home_download.save!
        redirect_to :action => :modify_home_page_download, :game_id => game_id, :type => @game_home_download.download_type
      end
    rescue
      render :text => "failed"
    end
  end

  def delete_home_download
    begin
      if request.post?
        game_id = params[:game_id].to_i
        download_id = params[:download_id].to_i

        @game_home_download = GameHomeDownload.find(:first, :conditions => ["id=:download_id AND game_id=:game_id", {:game_id => game_id, :download_id => download_id}])
        raise "no home download" unless @game_home_download

        unless @game_home_download.destroy
          raise
        end
        render :json => {:result => RET_SUCCESS}
      end
    rescue
      render :json => {:result => RET_FAILED}
    end
  end

  def update_home_video
    begin
      if request.post?
        game_id = params[:game_id].to_i
        video_id = params[:video_id].to_i
        type = params[:type]

        @game_home_video = GameHomeVideo.find(:first, :conditions => ["id=:video_id AND game_id=:game_id", {:game_id => game_id, :video_id => video_id}])
        raise "no home video" unless @game_home_video

        if type != "privilege"
          @game_home_video.video_title = params[:game_home_video][:video_title]
          @game_home_video.video_url = params[:game_home_video][:video_url]

          # save the picture
          if params[:game_home_video][:screenshot_url]
            ret = save_template_image(params[:game_home_video][:screenshot_url], "picture", "screenshot", game_id)
            raise I18n.t("page.admin.template.error.upload_failed") unless ret
            @game_home_video.screenshot_url = ret[:url]
          end

          @game_home_video.save!
        else
          position = params[:position].to_i
          if position > @game_home_video.privilege.to_i
            ActiveRecord::Base.transaction do
              connection = ActiveRecord::Base.connection
              sql_str = "UPDATE game_home_videos SET privilege=privilege-1 WHERE game_id=#{game_id} AND privilege>#{@game_home_video.privilege} AND privilege<=#{position}"
              connection.execute(sql_str)
              @game_home_video.privilege = position
              @game_home_video.save!
            end
          elsif position < @game_home_video.privilege.to_i
            ActiveRecord::Base.transaction do
              connection = ActiveRecord::Base.connection
              sql_str = "UPDATE game_home_videos SET privilege=privilege+1 WHERE game_id=#{game_id} AND privilege<#{@game_home_video.privilege} AND privilege>=#{position}"
              connection.execute(sql_str)
              @game_home_video.privilege = position
              @game_home_video.save!
            end
          end
        end

        if request.xhr?
          render :json => {:result => RET_SUCCESS}
        else
          redirect_to :action => :modify_home_page_video, :game_id => game_id
        end
      end
    rescue => e
      if request.xhr?
        render :json => {:result => RET_FAILED}
      else
        render :text => e.message
      end
    end
  end

  def create_home_video
    begin
      if request.post?
        game_id = params[:game_id].to_i
        @game_home_page = GameHomePage.find(:first, :conditions => ["game_id=:game_id", {:game_id => game_id}])
        raise "no home page" unless @game_home_page

        max_privilege = GameHomeVideo.find(:first, :select => "MAX(privilege) AS max_privilege", :conditions => ["game_id=:game_id", {:game_id => game_id}]).max_privilege.to_i
        max_privilege = 0 unless max_privilege
        @game_home_video = GameHomeVideo.new
        @game_home_video.game_id = game_id
        @game_home_video.video_title = params[:game_home_video][:video_title]
        @game_home_video.video_url = params[:game_home_video][:video_url]
        @game_home_video.privilege = max_privilege + 1

        # save the picture
        if params[:game_home_video][:screenshot_url]
          ret = save_template_image(params[:game_home_video][:screenshot_url], "picture", "screenshot", game_id)
          raise I18n.t("page.admin.template.error.upload_failed") unless ret
          @game_home_video.screenshot_url = ret[:url]
        end

        @game_home_video.save!
        redirect_to :action => :modify_home_page_video, :game_id => game_id
      end
    rescue => e
      render :text => e.message
    end
  end

  def delete_home_video
    begin
      if request.post?
        game_id = params[:game_id].to_i
        video_id = params[:video_id].to_i

        ActiveRecord::Base.transaction do
          @game_home_video = GameHomeVideo.find(:first, :conditions => ["id=:video_id AND game_id=:game_id", {:game_id => game_id, :video_id => video_id}], :lock => "LOCK IN SHARE MODE")
          raise "no home video" unless @game_home_video

          # update the privilege
          connection = ActiveRecord::Base.connection
          sql_str = "UPDATE game_home_videos SET privilege=privilege-1 WHERE game_id=#{game_id} AND privilege>#{@game_home_video.privilege} "
          connection.execute(sql_str)
          unless @game_home_video.destroy
            raise
          end
        end
        render :json => {:result => RET_SUCCESS}
      end
    rescue
      render :json => {:result => RET_FAILED}
    end
  end

  private

  def validate_idt
    err = AdminController.validate_identity(session[:admin_identity], Role::ID_EDIT_GAMES)
    unless  err == nil
      render(:text => err)
    end
  end

  def save_template_image(data, type, subtype, game_id)
    begin
      ext = nil
      data = data.read
      case data[0..9]
        when Regex.new('^GIF8'.force_encoding("US_ASCII"))
          ext = 'gif'
        when Regex.new('^\x89PNG'.force_encoding("US_ASCII"))
          ext = 'png'
        when Regex.new('^\xff\xd8\xff\xe0\x00\x10JFIF'.force_encoding("US_ASCII"))
          ext = 'jpg'
        when Regex.new('^\xff\xd8\xff\xe1(.*){2}Exif'.force_encoding("US_ASCII"))
          ext = 'jpg'
        else
          return nil
      end

      return nil unless ext

      file_dir = "#{Rails.root}/public/images/game_home_page"
      Dir.mkdir(file_dir) unless File.exist?(file_dir)
      return nil unless File.directory?(file_dir)

      if type == "template"
        f = File.open(File.join(file_dir, "#{game_id}_#{subtype}.#{ext}"), "wb")
        f.write(data)
        f.close
        {:path => File.join(file_dir, "#{game_id}_#{type}_#{ext}"), :url => "/images/game_home_page/#{game_id}_#{subtype}.#{ext}"}
      elsif type == "picture"
        uuid = UUIDTools::UUID.timestamp_create.to_s.delete('-')
        file_path = File.join(file_dir, "#{game_id}_#{uuid}.#{ext}")
        f = File.open(file_path, "wb")
        f.write(data)
        f.close

        #resize
        dest_file = File.join(file_dir, "#{game_id}_#{uuid}_s.#{ext}")
        ret = resize_image?(file_path, dest_file, 300)
        raise "resize failed" unless ret
        {:path => file_path, :thumbnail => dest_file, :url => "/images/game_home_page/#{game_id}_#{uuid}.#{ext}", :thumbnail_url => "/images/game_home_page/#{game_id}_#{uuid}_s.#{ext}"}
      else
        nil
      end
    rescue
      nil
    end
  end
end

