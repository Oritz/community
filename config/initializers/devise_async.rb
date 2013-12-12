# Supported options: :resque, :sidekiq, :delayed_job, :queue_classic, :torquebox
Devise::Async.backend = :sidekiq
Devise::Async.enabled = true
