json.status "success"
json.data do
  json.playtime_forever @statistic[:playtime_forever]
  json.achievements_count @statistic[:achievements_count]
  json.rank @statistic[:rank]
  json.delta_reputation @statistic[:delta_reputation]
  json.user_type @statistic[:user_type]
  json.ranklists @ranklists do |ranklist|
    json.game_id ranklist.game_id
    json.rank ranklist.rank
    json.user_type ranklist.user_type
    json.user_id ranklist.user_id
    if ranklist.user_type == "SteamUser"
      if ranklist.user.account
        json.nick_name ranklist.user.account_nick_name
        json.avatar ranklist.user.account_avatar
      else
        json.nick_name ranklist.user.personaname
        json.avatar ranklist.user.avatar
      end
    else
      json.nick_name ranklist.user.nick_name
      json.avatar ranklist.user.avatar
    end
  end
end
