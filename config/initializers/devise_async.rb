# Supported options: :resque, :sidekiq, :delayed_job, :queue_classic, :torquebox
Devise::Async.setup do |config|
  config.enabled = true
  config.backend = :sidekiq
end
