# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :steam_game do
    sequence(:appid) { |n| n }

    after(:create) do |g|
      FactoryGirl.create(:all_game, subable: g)
    end
  end
end
