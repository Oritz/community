require 'spec_helper'
require 'sonkwo/exp'

module Sonkwo
  describe Exp do
    let(:account) { create(:account) }
    let(:exp_strategy_once) { create(:exp_strategy_once, time_limit: 10, value: 1) }
    let(:exp_strategy_day) { create(:exp_strategy_day, time_limit: 10, value: 1) }
    let(:exp_strategy_unlimited) { create(:exp_strategy_unlimited, value: 1) }

    it "should do nothing with invalid app_name" do
      Sonkwo::Exp.increase("unused_name", account, Time.now)
      expect(account.exp).to eq 0
    end

    it "should do nothing with an exp_strategy which is closed" do
      closed_strategy = create(:exp_strategy_once, status: ExpStrategy::STATUS_CLOSED)
      accounts_exp_strategy = AccountsExpStrategy.where(account_id: account.id, exp_strategy_id: closed_strategy.id).first
      Sonkwo::Exp.increase(closed_strategy.app_name, account, Time.now)
      expect(accounts_exp_strategy.period_count).to eq 0
      expect(account.exp).to eq 0
    end

    it "should do nothing with an exp_strategy which value is 0 and bonus is 0" do
      exp_strategy = create(:exp_strategy_once, value: 0, bonus: 0)
      accounts_exp_strategy = AccountsExpStrategy.where(account_id: account.id, exp_strategy_id: exp_strategy.id).first
      Sonkwo::Exp.increase(exp_strategy.app_name, account, Time.now)
      expect(accounts_exp_strategy.period_count).to eq 0
      expect(account.exp).to eq 0
    end

    context "type_once" do
      it "should add exp and add bonus at the first time" do
        now = Time.now
        Sonkwo::Exp.increase(exp_strategy_once.app_name, account, now)

        accounts_exp_strategy = AccountsExpStrategy.where(account_id: account.id, exp_strategy_id: exp_strategy_once.id).first

        expect(accounts_exp_strategy.period_count).to eq 1
        expect(accounts_exp_strategy.last_added_at.to_i).to eq now.to_i
        expect(account.exp).to eq exp_strategy_once.value
        expect(account.bonus).to eq exp_strategy_once.bonus
      end

      it "should not add exp and bonus at the second time" do
        now = Time.now

        Sonkwo::Exp.increase(exp_strategy_once.app_name, account, now)
        Timecop.freeze(now + 1000)
        Sonkwo::Exp.increase(exp_strategy_once.app_name, account, now)
        Timecop.return

        accounts_exp_strategy = AccountsExpStrategy.where(account_id: account.id, exp_strategy_id: exp_strategy_once.id).first

        expect(accounts_exp_strategy.period_count).to eq 1
        expect(accounts_exp_strategy.last_added_at.to_i).to eq now.to_i
        expect(account.exp).to eq exp_strategy_once.value
        expect(account.bonus).to eq exp_strategy_once.bonus
      end
    end

    context "type_day" do
      it "should add exp if period_count is less than time_limit" do
        now = Time.now
        Sonkwo::Exp.increase(exp_strategy_day.app_name, account, now)
        Timecop.freeze(now + 1000)
        now = Time.now
        Sonkwo::Exp.increase(exp_strategy_day.app_name, account, now)
        Timecop.return

        accounts_exp_strategy = AccountsExpStrategy.where(account_id: account.id, exp_strategy_id: exp_strategy_day.id).first

        expect(accounts_exp_strategy.period_count).to eq 2
        expect(accounts_exp_strategy.last_added_at.to_i).to eq now.to_i
        expect(account.exp).to eq (exp_strategy_day.value * 2)
        expect(account.bonus).to eq (exp_strategy_day.bonus * 2)
      end

      it "should add exp next day" do
        now = Time.now
        Sonkwo::Exp.increase(exp_strategy_day.app_name, account, now)
        Timecop.freeze(now + 3600*24)
        now = Time.now
        Sonkwo::Exp.increase(exp_strategy_day.app_name, account, now)
        Timecop.return

        accounts_exp_strategy = AccountsExpStrategy.where(account_id: account.id, exp_strategy_id: exp_strategy_day.id).first

        expect(accounts_exp_strategy.period_count).to eq 1
        expect(accounts_exp_strategy.last_added_at.to_i).to eq now.to_i
        expect(account.exp).to eq (exp_strategy_day.value * 2)
        expect(account.bonus).to eq (exp_strategy_day.bonus * 2)
      end

      it "should not add if period_count is greater than or equal to time_limit" do
        Timecop.freeze(Time.now)
        (exp_strategy_day.time_limit + 1).times do
          Sonkwo::Exp.increase(exp_strategy_day.app_name, account, Time.now)
        end

        accounts_exp_strategy = AccountsExpStrategy.where(account_id: account.id, exp_strategy_id: exp_strategy_day.id).first

        expect(accounts_exp_strategy.period_count).to eq exp_strategy_day.time_limit
        expect(accounts_exp_strategy.last_added_at.to_i).to eq Time.now.to_i
        expect(account.exp).to eq (exp_strategy_day.value * exp_strategy_day.time_limit)
        expect(account.bonus).to eq (exp_strategy_day.bonus * exp_strategy_day.time_limit)
        Timecop.return
      end
    end

    context "type_unlimited" do
      it "should add exp" do
        Timecop.freeze(Time.now)
        Sonkwo::Exp.increase(exp_strategy_unlimited.app_name, account, Time.now)
        accounts_exp_strategy = AccountsExpStrategy.where(account_id: account.id, exp_strategy_id: exp_strategy_unlimited.id).first

        expect(accounts_exp_strategy.period_count).to eq 1
        expect(accounts_exp_strategy.last_added_at.to_i).to eq Time.now.to_i
        expect(account.exp).to eq exp_strategy_unlimited.value
        expect(account.bonus).to eq exp_strategy_unlimited.value
        Timecop.return
      end
    end
  end
end
