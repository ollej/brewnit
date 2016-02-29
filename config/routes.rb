Rails.application.routes.draw do
  namespace :admin do
    resources :users
    resources :media
    resources :recipes

    root to: "users#index"
  end

  get 'add_media/create'

  get 'open_search/show'
  get 'likes/update'

  mount Commontator::Engine => '/commontator'
  resources :recipes do
    resources :media, only: [:create, :destroy]
    resource :add_medium, only: [:create], controller: :add_medium
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
end
