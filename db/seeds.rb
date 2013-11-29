# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# seed the system_settings

# Build exp_strategies
exp_configs = Settings.exp
exp_strategies = ExpStrategy.all
accounts = Account.all

exp_strategies.each do |exp_strategy|
  next if exp_configs[exp_strategy.app_name]
  exp_strategy.destroy
end

exp_configs.each do |app_name, values|
  exp_strategy = ExpStrategy.where(app_name: app_name).first
  next if exp_strategy
  exp_strategy = ExpStrategy.new(app_name: app_name,
                                 name: values["name"],
                                 period_type: values["period_type"].to_i,
                                 time_limit: values["time_limit"].to_i,
                                 value: values["value"].to_i,
                                 data: values["data"])
  exp_strategy.status = values[:status].to_i
  exp_strategy.save!
end
