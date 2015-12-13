Rails.application.routes.draw do
  root :to => 'home#index'
  resources :sessions, only: [:new] do
    collection do
      get 'auth'
    end
  end
end
