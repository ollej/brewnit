Rails.application.routes.draw do
  get 'likes/update'

  mount Commontator::Engine => '/commontator'
  resources :recipes do
    member do
      post :like, controller: :likes, action: :create
      delete :like, controller: :likes, action: :destroy, as: :unlike
    end
  end
  devise_for :users, controllers: { omniauth_callbacks: 'omniauth_callbacks' }
  root to: 'recipes#index'
end
