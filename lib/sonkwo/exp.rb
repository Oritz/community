module Sonkwo
  module Exp
    class << self
      def level(exp)
        exp = exp.to_i
        return 0 if exp < 0
        level_values = Settings.level
        count = level_values.count
        return count+1 if exp > level_values[count - 1]
        level_values.each_with_index do |value, i|
          return i+1 if value >= exp
        end
      end

      def increase(app_name, account, added_at)
        return unless account
        exp_strategy = ExpStrategy.where(app_name: app_name).first
        return unless exp_strategy
        return if exp_strategy.status == ExpStrategy::STATUS_CLOSED || (exp_strategy.value == 0 && exp_strategy.bonus == 0)

        accounts_exp_strategy = AccountsExpStrategy.where(account_id: account.id, exp_strategy_id: exp_strategy.id).first
        return unless accounts_exp_strategy
        last_added_at = accounts_exp_strategy.last_added_at
        period_count = accounts_exp_strategy.period_count
        today = Date.today
        time_limit = exp_strategy.time_limit

        case exp_strategy.period_type
        when ExpStrategy::TYPE_ONCE
          return if time_limit == 0
          return if accounts_exp_strategy.period_count >= 1
          accounts_exp_strategy.last_added_at = added_at
          accounts_exp_strategy.period_count = 1
        when ExpStrategy::TYPE_DAY
          return if last_added_at && last_added_at > today && period_count >= time_limit
          period_count = 0 if !last_added_at || last_added_at < today
          accounts_exp_strategy.last_added_at = added_at
          accounts_exp_strategy.period_count = period_count + 1
        when ExpStrategy::TYPE_UNLIMITED
          accounts_exp_strategy.period_count += 1
          accounts_exp_strategy.last_added_at = added_at
        else
          raise "not supported"
        end

        accounts_exp_strategy.save!
        account.exp += exp_strategy.value
        account.bonus += exp_strategy.bonus
        account.save!
      end
    end
  end
end
