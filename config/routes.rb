require 'sidekiq/web'

Rails.application.routes.draw do
  ActiveAdmin.routes(self)

  get 'account',                  to: 'dashboard#index', as: 'dashboard'
  get '/auth/:provider/callback', to: 'connections#create'
  get 'api/uid',                  to: 'api#uid'
  get 'api/userUid',              to: 'api#userUid'
  get 'api/dividends',            to: 'api#dividends'
  get 'api/events',               to: 'api#events'
  get 'graphs/full',              to: 'graphs#full'
  get 'graphs/friends',           to: 'graphs#friends'
  get 'graphs/strangers',         to: 'graphs#strangers'
  get 'graphs/access',            to: 'graphs#access'
  get 'about',                    to: 'home#about', as: :about
  get 'fellowship',               to: 'home#fellowship', as: :fellowship
  get 'hire',                     to: 'home#hire', as: :hire
  post 'webhooks',                to: 'webhooks#index'
  get 'export/users',             to: 'export#users'
  get 'export/connections',       to: 'export#connections'
  get 'export/entries',           to: 'export#entries'

  resources :connections, only: [:destroy] do
    collection do
      get :check_friends
    end
  end

  resource :subscription, only: [:edit, :update, :destroy] do
    get :checkout
    post :process_card
  end

  resource :user, only: :update
  resources :events, only: :index

  devise_for :users, path: 'account', controllers: { registrations: 'users/registrations' }

  devise_scope :user do
    get 'membership', to: 'users/registrations#new'
  end

  authenticate :user, lambda { |u| u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  root to: 'home#index'

  get '*unmatched_route', to: 'application#route_not_found', constraints: { format: :html }
end
