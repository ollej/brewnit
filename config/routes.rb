Rails.application.routes.draw do
  resources :recipes
  devise_for :users, controllers: { omniauth_callbacks: 'omniauth_callbacks' }
  root to: 'recipes#index'
end
