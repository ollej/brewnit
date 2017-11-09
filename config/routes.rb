Rails.application.routes.draw do
  resources :events do
    resources :media, only: [:create, :destroy]
    resource :add_medium, only: [:create], controller: :add_medium
    resources :recipes, only: [:index], controller: :event_recipes
  end

  namespace :admin do
    resources :users
    resources :media
    resources :recipes
    resources :events

    root to: "users#index"
  end

  get 'add_media/create'

  get 'open_search/show'
  get 'likes/update'

  mount Commontator::Engine => '/commontator'
  resources :recipes do
    resources :media, only: [:create, :destroy]
    resource :add_medium, only: [:create], controller: :add_medium
    resources :events, only: [:create, :destroy], controller: :recipe_events
    member do
      post :like, controller: :likes, action: :create
      delete :like, controller: :likes, action: :destroy, as: :unlike
    end
  end

  devise_for :users, controllers: {
    omniauth_callbacks: 'omniauth_callbacks',
    registrations: 'users/registrations'
  }
  resources :users, only: [:index, :show] do
    resources :media, only: [:create, :destroy]
    resource :add_medium, only: [:create], controller: :add_medium
  end

  resources :latest_items, only: [:index]

  root to: 'latest_items#index'

  get '/404.html', to: redirect('/404.html')
  get '/500.html', to: redirect('/500.html')

  match '*path', via: :all, to: 'pages#error_404'
end
