class GamesController < ApplicationController
  def ranklist
    @game = AllGame.find(params[:id])
    @ranklists = @game.ranklists.order("reputation DESC").includes(:user).tap do |ranklists|
      ids = ranklists.inject([]) do |result, elm|
        result << elm.user_id if elm.user_type == "SteamUser"
        result
      end

      steam_user_accounts = Account.where(id: ids).select("nick_name, avatar")
      hashes = steam_user_accounts.inject({}) do |result, elm|
        result[elm.id] = elm
        result
      end

      ranklists.each { |ranklist| ranklist.user.account = hashes[ranklist.user_id] if ranklist.user_type == "SteamUser" }
    end

    respond_to do |format|
      format.html
      format.json
    end
  end
end
