require 'platforms/platform'

module Platform
  class SteamSettings < Settingslogic
    source "#{Rails.root}/lib/platforms/steam/steam.yml"
    namespace Rails.env
  end

  class Steam
    extend Network

    class << self
      def api_key
        unless @api_key
          game_platform = GamePlatform.where(name: "steam").first
          @api_key = game_platform ? game_platform.api_key : nil
        end
        @api_key
      end

      def fetch_data_for_user(steam_user)
        steam_user = SteamUser.where(steamid: steam_user).first if steam_user.is_a?(String)
        return nil unless steam_user

        get_player_summaries(steam_user.steamid)
        get_owned_games(steam_user.steamid)
        games = steam_user.games.includes(:subable)
        games.each do |game|
          appid = game.subable.appid
          get_player_achievements(appid, steam_user.steamid)
        end
      end

      def fetch_all_data
        steam_users = SteamUser.where("account_id IS NOT NULL").all
        steam_users.each do |steam_user|
          fetch_data_for_user(steam_user)
          get_friend_list(steam_user.steamid)
        end
      end

      def get_player_summaries(steamids)
        valid_steamids = []
        steamids = [steamids] if steamids.is_a?(String)
        steamids.each do |steamid|
          valid_steamids << steamid if check_steamid(steamid)
        end

        url = build_url("get_player_summaries", key: self.api_key, steamids: valid_steamids)
        response = get(url)
        return unless response

        players = response["response"]["players"] || []
        steam_users = []
        attrs = {
          "personaname" => "string",
          "profile_url" => "string",
          "avatar" => "string",
          "communityvisibilitystate" => "int",
          "profilestate" => "int",
          "lastlogoff" => "int",
          "commentpermission" => "int",
          "realname" => "string",
          "primaryclanid" => "string",
          "timecreated" => "int",
          "loccountrycode" => "string",
          "locstatecode" => "string",
          "loccity" => "int"
        }

        players.each do |player|
          player_steamid = player["steamid"]
          steam_user = SteamUser.where(steamid: player_steamid).first
          steam_user = SteamUser.new unless steam_user

          attrs.each do |k, t|
            if player[k]
              value = convert_value(t, player[k])
              steam_user.send(k + "=", value)
            end
          end

          steam_user.save
          steam_users << steam_user unless steam_user.errors.present?
          # TODO: log the error items
        end
        steam_users
      end

      def get_friend_list(steamid)
        return unless check_steamid(steamid)

        steam_user = SteamUser.where(steamid: steamid).first
        return unless steam_user

        url = build_url("get_friend_list", key: self.api_key, steamid: steamid)
        response = get(url)
        return unless response

        steam_friends = []
        friends = response["friendslist"]["friends"] || []
        friends.each do |friend|
          friend_steamid = friend["steamid"]
          friend = SteamUser.where(steamid: friend_steamid).first
          next unless friend

          friend_since = friend["friend_since"].to_i
          steam_friend = SteamFriend.new(friend_since: friend_since)
          steam_friend.steam_user = steam_user
          steam_friend.friend = friend
          steam_friend.save

          steam_friends << steam_friend unless steam_friend.errors.present?
        end

        steam_friends
      end

      def get_player_achievements(appid, steamid)
        return unless check_steamid(steamid)
        steam_user = SteamUser.where(steamid: steamid).first
        return unless steam_user
        steam_game = SteamGame.where(appid: appid).first
        return unless steam_game
        url = build_url("get_player_achievements", key: self.api_key, steamid: steamid, appid: appid)
        response = get(url)
        return unless response

        playerstats = response["playerstats"]
        return unless playerstats["success"]

        achievements = playerstats["achievements"] || []
        achievements.each do |achievement|
          apiname = achievement["apiname"]
          achieved = achievement["achieved"].to_i

          next if achieved != 1
          steam_achievement = SteamGameAchievement.where(api_name: apiname, steam_game_id: steam_game.id).first
          next unless steam_achievement
          game_achievement = steam_achievement.game_achievement
          steam_user.game_achievements << game_achievement unless steam_user.game_achievements.exists?(game_achievement)
        end

        true
      end

      #def get_user_stats_for_game(appid, steamid)
      #end

      def get_owned_games(steamid)
        steam_user = SteamUser.where(steamid: steamid).first
        return unless steam_user
        url = build_url("get_owned_games", key: self.api_key, steamid: steam_user.steamid)
        response = get(url)
        return unless response
        return unless response["response"]

        play_games = response["response"]["games"] || []
        play_games.each do |play_game|
          appid = play_game["appid"]
          playtime_forever = play_game["playtime_forever"] ? play_game["playtime_forever"].to_i : nil
          playtime_2weeks = play_game["playtime_2weeks"] ? play_game["playtime_2weeks"].to_i : nil
          if play_game["has_community_visible_stats"]
            # TODO: to record the url
            is_enable = false
          else
            is_enable = true
          end

          steam_game = SteamGame.where(appid: appid).first
          next unless steam_game
          game = steam_game.game
          next unless game

          steam_users_game = SteamUsersGame.where(steam_user_id: steam_user.id, game_id: game.id).first
          steam_users_game = SteamUsersGame.new unless steam_users_game
          steam_users_game.steam_user = steam_user
          steam_users_game.game = game
          steam_users_game.playtime_forever = playtime_forever
          steam_users_game.playtime_2weeks = playtime_2weeks
          steam_users_game.has_community_visible_stats = is_enable ? SteamUsersGame::VISIBLE_STATS_ENABLE : SteamUsersGame::VISIBLE_STATS_DISABLE
          steam_users_game.save!
        end

        true
      end

      def get_recently_played_games(steamid)
      end

      private
      def convert_value(type, value)
        if type == "int"
          value.to_i
        elsif type == "string"
          value.to_s
        else
          raise "type #{type} is not valid"
        end
      end

      def check_steamid(steamid)
        return false unless steamid
        return false unless steamid.is_a?(String)
        return false if steamid.to_i.to_s != steamid
        return false if steamid.to_i > ("FF"*8).hex
        true
      end

      def build_url(block_name, args={})
        begin
          block = SteamSettings.send(block_name)
        rescue
          return ""
        end

        str_args = {}
        args.each { |k, v| str_args[k.to_s] = v }

        arguments = block.arguments
        url = block.url
        params = []
        arguments.each do |k, v|
          if v == true
            raise "#{k} could not be nil in args" unless str_args[k.to_s]
            params << "#{k}=#{str_args[k]}"
          elsif k.to_s == "steamids"
            max_count = arguments.steamids.max_count
            steamids = str_args["steamids"]
            raise "steamids is more than #{max_count}" if steamids.length > max_count
            params << "#{k}=#{steamids * ','}"
          else
            params << "#{k}=#{v}"
          end
        end
        params_str = params * '&'

        params_str == "" ? url : "#{url}?#{params_str}"
      end
    end
  end
end
