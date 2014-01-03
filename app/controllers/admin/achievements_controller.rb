class Admin::AchievementsController < AdminController
  # GET /admin/achievements
  # GET /admin/achievements.json
  def index
    @admin_achievements = GameAchievement.where('game_id=?', params[:all_game_id])
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @admin_achievements }
    end
  end

  # GET /admin/achievements/1
  # GET /admin/achievements/1.json
  def show
    @admin_achievement = GameAchievement.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @admin_achievement }
    end
  end

  # GET /admin/achievements/new
  # GET /admin/achievements/new.json
  def new
    @admin_achievement = AllGame.find(params[:all_game_id]).game_achievements.build
    @admin_achievement.subable = @admin_achievement.get_subable
    
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @admin_achievement }
    end
  end

  # GET /admin/achievements/1/edit
  def edit
    @admin_achievement = GameAchievement.find(params[:id])
  end

  # POST /admin/achievements
  # POST /admin/achievements.json
  def create
    game = AllGame.find(params[:all_game_id])
    game_achievement = game.game_achievements.build(params[:game_achievement])
    game_achievement.subable.steam_game_id = game.subable_id
    respond_to do |format|
      if game_achievement.save!
        format.html { redirect_to admin_all_game_achievements_path, notice: 'Achievement was successfully created.' }
      else
        format.html { redirect_to new_admin_all_game_achievement_path}
      end
    end
  end

  # PUT /admin/achievements/1
  # PUT /admin/achievements/1.json
  def update
    @admin_achievement = GameAchievement.find(params[:id])

    respond_to do |format|
      if @admin_achievement.update_attributes(params[:game_achievement])
        format.html { redirect_to admin_all_game_achievements_path, notice: 'Achievement was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @admin_achievement.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/achievements/1
  # DELETE /admin/achievements/1.json
  def destroy
    @admin_achievement = GameAchievement.find(params[:id])
    @admin_achievement.subable.delete
    @admin_achievement.delete

    respond_to do |format|
      format.html { redirect_to admin_all_game_achievements_url }
      format.json { head :no_content }
    end
  end
end
