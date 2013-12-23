require 'platforms/steam/steam'

class FetchSteamUserWorker
  include Sidekiq::Worker
  def perform(steamid)
    Platform::Steam.fetch_data_for_user(steamid)
  end
end
