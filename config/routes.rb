Rails.application.routes.draw do
  get 'pages/:page' => 'pages#show', as: :pages

  resources :events do
    resources :media, only: [:create, :destroy]
    resource :add_medium, only: [:create], controller: :add_medium
    resources :recipes, only: [:index, :create], controller: :event_recipes
  end

  namespace :admin do
    resources :users
    resources :media
    resources :recipes
    resources :events

    root to: 'users#index'
  end

  get 'add_media/create'

  get 'open_search/show'
  get 'likes/update'

  mount Commontator::Engine => '/commontator'

  resources :recipes do
    resources :media, only: [:create, :destroy]
    resource :add_medium, only: [:create], controller: :add_medium
    resources :events, only: [:index, :create, :destroy], controller: :recipe_events
    member do
      post :like, controller: :likes, action: :create
      delete :like, controller: :likes, action: :destroy, as: :unlike
    end
    resources :placements, only: [:destroy], controller: :recipe_placements
    resource :details, only: [:show, :update], controller: :recipe_details
    resources :fermentables, only: [:index, :create, :destroy], controller: :recipe_fermentables
    resources :hops, only: [:index, :create, :destroy], controller: :recipe_hops
    resources :miscs, only: [:index, :create, :destroy], controller: :recipe_miscs
    resources :yeasts, only: [:index, :create, :destroy], controller: :recipe_yeasts
    resources :mash_steps, only: [:index, :create, :destroy], controller: :recipe_mash_steps
    resource :complete, only: [:update], controller: :recipe_complete
    member do
      get :clone, to: 'clone_recipe#new'
      post :clone, to: 'clone_recipe#create'
    end
  end

  get :register_recipe, controller: :register_recipe, action: :new
  post :register_recipe, controller: :register_recipe, action: :create

  devise_for :users, controllers: {
    omniauth_callbacks: 'omniauth_callbacks',
    registrations: 'users/registrations',
    sessions: 'users/sessions'
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
