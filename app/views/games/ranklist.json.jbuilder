json.status "success"
json.data @ranklists do |ranklist|
  json.game_id ranklist.game_id
  json.rank ranklist.rank
  json.user_type ranklist.user_type
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
