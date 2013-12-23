# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :game_achievement do |g|
    association :game, factory: :game_with_steam
    name "achievement name"
    description "achievement description"
    lock_url "lock_url"
    unlock_url "unlock_url"
    status GameAchievement::STATUS_NORMAL
    subable nil

    #trait :game_achievement_steam_subable do
    #  association :subable, factory: :steam_game_achievement
    #end

    #factory :game_achievement_with_steam, traits: [:game_achievement_steam_subable]
  end
end
