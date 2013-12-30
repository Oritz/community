SonkwoCommunity::Application.routes.draw do
  begin
    devise_for :accounts, :controllers => { :sessions => 'account_sessions', :registrations => 'account_registrations' }
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

  resources :talks, only: [:show, :create]
  resources :subjects, only: [:show, :new, :create, :edit, :update] do
    resources :post_images, only: [:create, :destroy]
  end

  resources :users, only: [:show] do
    collection do
      put 'follow'
      delete 'unfollow'
      get 'check_name'
    end
    member do
      get 'groups'
      get 'posts'
      get 'people'
      get 'games'
    end
    resources :albums, only: [:index, :create, :show, :new] do
      resources :photos, only: [:index, :create]
    end
  end
  post 'photos/screenshot', to: 'photos#screenshot'

  resources :home, only: [:index] do
    collection do
      get 'index'
      get 'groups'
      get 'people'
      get 'posts'
      get 'notification'
      get 'recommended'
      put 'tags/:tag_id', to: 'home#add_tag'
      delete 'tags/:tag_id', to: 'home#remove_tag'
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

  resources :informations, only: [:index] do
    collection do
      get :groups
      get :friends
      get :clients
      get :tags
      post :confirm_step
    end
  end

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
  namespace :admin do
    resources :games do
      member do
        get :pre_release_list
        get :submit_release
        get :new_pre_release
        get :audit_release
        get :game_serial_numbers
        get :delete_selection
        get :game_serial_type
        post :pre_release_list
        post :submit_release
        post :new_pre_release
        post :cancel_pre_release
        post :audit_release
        put :import_serials
        put :game_serial_type
      end
    end
    resources :auth_items
    resources :accounts
    resources :serial_types
    resources :download_servers
    resources :clients
    resources :recommendations
    get '/', to: 'admin#index'
  end
end
