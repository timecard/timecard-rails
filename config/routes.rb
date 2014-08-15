Timecard::Application.routes.draw do
  resource :dashboard, only: :show
  devise_for :users, controllers:  { omniauth_callbacks: "users/omniauth_callbacks", registrations: 'users/registrations' }
  resources :users, only: [:show] do
    resources :workloads, only: [:index] do
      get '/:year/:month/:day', on: :collection, to: 'workloads#index', as: :daily
    end
    resources :authentications
    resources :reports, only: :index
  end

  resources :members, only: [:destroy]
  resources :data

  resources :comments, only: [:edit, :update, :destroy]
  resources :workloads, only: [:edit, :update, :destroy, :stop] do
    patch :stop, on: :member
  end

  resources :issues, only: [:index, :show, :edit, :update, :close, :reopen] do
    patch :close, on: :member
    patch :reopen, on: :member
    patch :postpone, on: :member
    patch :do_today, on: :member
    resources :comments, only: [:create]
    resource :workloads, only: :create
  end

  resources :projects do
    patch :active, on: :member
    patch :close, on: :member
    resources :issues, only: [:index, :new, :create]
    resources :members, only: [:index, :create]
    resources :crowdworks_contracts, only: [:new, :create]
    resources :reports, only: :index
  end

  resources :crowdworks_contracts, only: [:edit, :update, :destroy]

  resources :reports, only: :index

  delete "users/disconnect/:provider", to: "users#disconnect", as: :disconnect_provider
  root :to => "home#index"
  mount API => "/"
end
