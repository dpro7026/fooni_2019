Rails.application.routes.draw do
  resources :events
  devise_for :users
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  get 'homepage/index'
  root 'events#index'
end
