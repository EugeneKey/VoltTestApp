require 'sidekiq/web'

Rails.application.routes.draw do
  authenticate :user do
    mount Sidekiq::Web => '/sidekiq'
  end
  use_doorkeeper
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: "doorkeeper/applications#index"

  namespace :api, defaults: { format: 'json' } do
    namespace :v1 do
      resources :posts, only: [:create, :show, :index]
      post 'reports/by_author', to: 'reports#by_author'
    end
  end

  namespace :profiles do
    get :me
    patch :avatar_update
  end
end
