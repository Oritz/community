SonkwoCommunity::Application.routes.draw do
  devise_for :accounts, :controllers => { :sessions => 'account_sessions' }
  root to: "home#index"

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
  end

  resource :talks, only: [:show, :create]
  resource :subject, only: [:show, :new, :create, :edit, :update]

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
  
  resources :cloud_storages

  # match ':controller(/:action(/:id))(.:format)'
end
