class GamesController < ApplicationController
  def ranklist
    @game = AllGame.find(params[:id])
    @ranklists = @game.ranklists.order("reputation DESC").fill_account
    respond_to do |format|
      format.html
      format.json
    end
  end
end
