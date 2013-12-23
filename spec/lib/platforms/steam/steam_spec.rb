require 'spec_helper'
require 'webmock/rspec'
require 'platforms/platform'
require 'platforms/steam/steam'

module Platform
  describe Steam do
    let!(:game_platform) { create(:game_platform, name: "steam", api_key: "api_key") }

    context "check_steamid" do
      it "should return true if steamid is valid" do
        expect(Steam.send("check_steamid", "76561198082595090")).to eq true
      end

      it "should return false if steamid is not valid" do
        expect(Steam.send("check_steamid", "notanumber")).to eq false
        expect(Steam.send("check_steamid", ("FF" * 9).hex.to_s)).to eq false
      end
    end

    it "should return api_key while calling api_key function" do
      expect(Steam.api_key).to eq game_platform.api_key
    end

    context "get_friend_list" do
      it "should return nil with invalid steamid" do
        expect(Steam.get_friend_list("13432")).to eq nil
      end

      it "should insert data" do
        steam_user = create(:steam_user)
        friend = create(:steam_user)

        steamid = steam_user.steamid
        body = "{\"friendslist\": {\"friends\": [{\"steamid\": \"76561198014725790\", \"relationship\": \"friend\", \"friend_since\": 1359362490}, {\"steamid\": \"#{friend.steamid}\", \"relationship\": \"friend\", \"friend_since\": 1359362490}, {\"steamid\": \"#{friend.steamid}\", \"relationship\": \"friend\", \"friend_since\": 1359362490}]}}"

        url = Steam.send("build_url", "get_friend_list", {key: Steam.api_key, steamid: steamid})
        stub_request(:get, url).to_return(
                                          status: 200,
                                          body: body,
                                          header: {
                                            'Content-Type' => 'application/json',
                                            'Content-Length' => body.length
                                          })

        steam_friends = Steam.get_friend_list(steamid)
        db_steam_friends = SteamFriend.all
        expect(db_steam_friends.count).to eq 1
      end
    end

    context "get player summaries" do
      it "should insert data with steamids" do
        steamids = ["76561198082595090", "76561197960435530"]
        body = "{ \"response\": { \"players\": [ { \"steamid\": \"76561198082595090\", \"communityvisibilitystate\": 3, \"profilestate\": 1, \"personaname\": \"air_mike\", \"lastlogoff\": 1384845832, \"profileurl\": \"http://steamcommunity.com/profiles/76561198082595090/\", \"avatar\": \"http://media.steampowered.com/steamcommunity/public/images/avatars/fe/fef49e7fa7e1997310d705b2a6158ff8dc1cdfeb.jpg\", \"avatarmedium\": \"http://media.steampowered.com/steamcommunity/public/images/avatars/fe/fef49e7fa7e1997310d705b2a6158ff8dc1cdfeb_medium.jpg\", \"avatarfull\": \"http://media.steampowered.com/steamcommunity/public/images/avatars/fe/fef49e7fa7e1997310d705b2a6158ff8dc1cdfeb_full.jpg\", \"personastate\": 0, \"primaryclanid\": \"103582791429521408\", \"timecreated\": 1359340417, \"personastateflags\": 0 }, { \"steamid\": \"76561197960435530\", \"communityvisibilitystate\": 3, \"profilestate\": 1, \"personaname\": \"Robin\", \"lastlogoff\": 1384907857, \"profileurl\": \"http://steamcommunity.com/id/robinwalker/\", \"avatar\": \"http://media.steampowered.com/steamcommunity/public/images/avatars/f1/f1dd60a188883caf82d0cbfccfe6aba0af1732d4.jpg\", \"avatarmedium\": \"http://media.steampowered.com/steamcommunity/public/images/avatars/f1/f1dd60a188883caf82d0cbfccfe6aba0af1732d4_medium.jpg\", \"avatarfull\": \"http://media.steampowered.com/steamcommunity/public/images/avatars/f1/f1dd60a188883caf82d0cbfccfe6aba0af1732d4_full.jpg\", \"personastate\": 0, \"realname\": \"Robin Walker\", \"primaryclanid\": \"103582791429521412\", \"timecreated\": 1063407589, \"personastateflags\": 0, \"loccountrycode\": \"US\", \"locstatecode\": \"WA\", \"loccityid\": 3961 } ] } } "
        url = Steam.send("build_url", "get_player_summaries", {key: Steam.api_key, steamids: steamids})
        stub_request(:get, url).to_return(
                                          status: 200,
                                          body: body,
                                          header: {
                                            'Content-Type' => 'application/json',
                                            'Content-Length' => body.length
                                          })

        steam_users = Steam.get_player_summaries(steamids)
        db_steam_users = SteamUser.all
        expect(steam_users).to eq db_steam_users
      end
    end

    context "get player achievements" do
      let!(:steam_user) { create(:steam_user) }
      let!(:steam_game) { create(:steam_game) }

      it "should return nil with invalid appid or invalid steamid" do
        expect(Steam.get_player_achievements(steam_game.appid,
                                             (steam_user.steamid.to_i + 1).to_s)).to eq nil
        expect(Steam.get_player_achievements(steam_game.appid + 1,
                                             steam_user.steamid)).to eq nil
      end

      it "should return nil with success is false" do
        body = "{\"playerstats\": {\"error\": \"Requested app has no stats\",\"success\": false} }"
        url = Steam.send("build_url",
                         "get_player_achievements",
                         {
                           key: Steam.api_key,
                           steamid: steam_user.steamid,
                           appid: steam_game.appid
                         })
        stub_request(:get, url).to_return(
                                          status: 200,
                                          body: body,
                                          header: {
                                            'Content-Type' => 'application/json',
                                            'Content-Length' => body.length
                                          })
        expect(Steam.get_player_achievements(steam_game.appid, steam_user.steamid)).to be_nil
      end

      it "should return insert data with success is true" do
        game_achievements = create_list(:steam_game_achievement, 10, steam_game: steam_game)
        body = "{\"playerstats\": {\"steamid\": \"#{steam_user.steamid}\", \"gameName\": \"#{steam_game.game.name}\", \"achievements\": [{\"apiname\": \"#{game_achievements[0].api_name}\", \"achieved\": 1},{\"apiname\": \"#{game_achievements[1].api_name}\", \"achieved\": 1},{\"apiname\": \"unstored_api_name\", \"achieved\": 1},{\"apiname\": \"#{game_achievements[2].api_name}\", \"achieved\": 0},{\"apiname\": \"#{game_achievements[1].api_name}\", \"achieved\": 1}], \"success\": true}}"
        url = Steam.send("build_url",
                         "get_player_achievements",
                         {
                           key: Steam.api_key,
                           steamid: steam_user.steamid,
                           appid: steam_game.appid
                         })
        stub_request(:get, url).to_return(
                                          status: 200,
                                          body: body,
                                          header: {
                                            'Content-Type' => 'application/json',
                                            'Content-Length' => body.length
                                          })
        expect(Steam.get_player_achievements(steam_game.appid, steam_user.steamid)).to be_true
        expect(SteamUsersGameAchievement.all.count).to eq 2
      end
    end

    context "get_owned_games" do
      let!(:steam_user) { create(:steam_user) }

      it "should return nil with invalid steamid" do
        expect(Steam.get_owned_games((steam_user.steamid.to_i + 1).to_s)).to be_nil
      end

      it "should return true with valid request" do
        steam_game = create(:steam_game)
        body = "{\"response\": {\"game_count\": 2, \"games\": [{\"appid\": #{steam_game.appid}, \"playtime_forever\": 50, \"playtime_2weeks\": 10},{\"appid\": #{steam_game.appid}, \"playtime_forever\": 50, \"playtime_2weeks\": 10}, {\"appid\": #{steam_game.appid+1}, \"playtime_forever\": 50}]}}"

        url = Steam.send("build_url",
                         "get_owned_games",
                         {
                           key: Steam.api_key,
                           steamid: steam_user.steamid,
                         })
        stub_request(:get, url).to_return(
                                          status: 200,
                                          body: body,
                                          header: {
                                            'Content-Type' => 'application/json',
                                            'Content-Length' => body.length
                                          })
        expect(Steam.get_owned_games(steam_user.steamid)).to be_true
        expect(SteamUsersGame.all.count).to eq 1
      end
    end
  end
end
