class Admin::AllGamesController < AdminController
  def index
    @q = AllGame.search(params[:q])
    @all_games = @q.result.page(params[:page]).per(20)
    @steam_games = @q.result.where('subable_type=?', 'SteamGame').page(params[:steam_page]).per(20)
  end

  def show
    @game = AllGame.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @game }
    end
  end

  def new
    @game = AllGame.new
    game_type = params[:game_type]
    @game.subable = game_type.constantize.new if(game_type && AllGame.have_type?(game_type))

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @game }
    end
  end

  # GET /admin/all_games/1/edit
  def edit
    @game = AllGame.find(params[:id])
  end

  # POST /admin/all_games
  # POST /admin/all_games.json
  def create
    @game = AllGame.new(params[:all_game])
    respond_to do |format|
      if @game.save!
        format.html { redirect_to admin_all_games_path, notice: 'game was successfully created.' }
        format.json { render json: @game, status: :created, location: @game }
      else
        format.html { render action: "new" }
        format.json { render json: @game.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /admin/all_games/1
  # PUT /admin/all_games/1.json
  def update
    @game = AllGame.find(params[:id])

    respond_to do |format|
      if @game.update_attributes(params[:all_game])
        format.html { redirect_to admin_all_games_path, notice: 'Game was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @game.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/all_games/1
  # DELETE /admin/all_games/1.json
  def destroy
    raise "Can't destroy games anymore, please using update instead"
    @game = AllGame.find(params[:id])
    @game.destroy

    respond_to do |format|
      format.html { redirect_to games_url }
      format.json { head :no_content }
    end
  end
end
