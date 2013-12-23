require 'sonkwo/reputation'

class RankReputationWorker
  include Sidekiq::Worker

  def perform
    Sonkwo::Reputation.rank
  end
end
