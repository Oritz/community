module Sonkwo
  module Reputation
    class << self
      def rank
        items = UsersGamesReputationRanklist.order("reputation DESC").all
        count = items.count
        reputation_settings = Settings.reputation

        last_item = nil
        items.each_with_index do |item, index|
          ratio = index.to_f / count
          reputation_settings.each_with_index do |value, r_i|
            value = value[1]
            from = value["range"]["from"].to_f
            to = value["range"]["to"].to_f
            next if ratio < to || ratio >= from
            item.rank = r_i
          end

          if item.rank <= 1
            item.delta_reputation = 0
          elsif item.rank == last_item.rank
            item.delta_reputation = last_item.reputation - item.reputation + last_item.delta_reputation
          else
            item.delta_reputation = last_item.reputation - item.reputation
          end

          item.save!
          last_item = item
        end
      end
    end
  end
end
