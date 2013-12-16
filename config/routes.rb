SonkwoCommunity::Application.routes.draw do
  begin
    devise_for :accounts, :controllers => { :sessions => 'account_sessions' }
  rescue Exception => e
    puts "Devise error: #{e.class}: #{e}"
  end

  root :to => "home_pages#index"

  resources :home_pages, only: [:index]
  resources :groups do
    member do
      put 'add_user'
      delete 'remove_user'
      post 'add_tags'
    end
  end

  resources :posts, only: [:show, :destroy] do
    resources :comments
    member do
      put 'like'
      delete 'unlike'
      post 'recommend'
    end
    collection do
      get 'templates'
    end
  end

  resource :talks, only: [:show, :create]
  resource :subject, only: [:show, :new, :create, :edit, :update] do
    resources :post_images, only: [:create, :destroy]
  end

  resources :users, only: [:show] do
    collection do
      put 'follow'
      delete 'unfollow'
    end
    member do
      get 'groups'
      get 'posts'
      get 'people'
      get 'games'
    end
  end

  resources :home, only: [:index] do
    collection do
      get 'index'
      get 'groups'
      get 'people'
      get 'posts'
      get 'notification'
      get 'recommended'
    end
  end

  resources :conversations, only: [:index, :show, :destroy]
  resources :private_messages, only: [:create, :destroy]
  resources :setting, only: [:index] do
    collection do
      get 'security'
      post 'bind'
      get 'bind_complete'
    end
  end

  resources :cloud_storages, only: [:new, :create] do
    collection do
      get 'template'
    end
  end

  resources :games, only: [] do
    resources :game_achievements, only: [:index, :show]
  end

  resources :albums do
    resources :photos, only: [:index, :create]
  end
  post 'photos/screenshot', to: 'photos#screenshot'

  # sidekiq
  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'

  # old routes (need to be cleaned in future)
  namespace :api do
    post 'client/post_err_msg', to: 'client#post_err_msg'
    get 'client/get_latest_client_version', to: 'client#get_latest_client_version'
    post 'user/post_action', to: 'user#post_action'
    post 'user/update_env', to: 'user#update_env'
    get 'user/get_play_time', to: 'user#get_play_time'
    get 'launch/get_launcher', to: 'launch#get_launcher'
    get 'game/list_my_games', to: 'game#list_my_games'
    get 'game/list_my_game_ids', to: 'game#list_my_game_ids'
    get 'game/get_game_info', to: 'game#get_game_info'
    get 'game/get_game_dlcs', to: 'game#get_game_dlcs'
    get 'game/request_game_shell', to: 'game#request_game_shell'
    get 'game/request_game_ini', to: 'game#request_game_ini'
    get 'game/get_game_seed', to: 'game#get_game_seed'
    get 'game/get_game_serial_number', to: 'game#get_game_serial_number'
    post 'game/register_serial_number', to: 'game#register_serial_number'
    get 'game/get_game_news', to: 'game#get_game_news'
  end
  # match ':controller(/:action(/:id))(.:format)'
end
