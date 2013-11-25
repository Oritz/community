require 'platforms/steam/steam'

class FetchSteamDataWorker
  include Sidekiq::Worker

  def perfom
    Platform::Steam.fetch_all_data
  end
end
