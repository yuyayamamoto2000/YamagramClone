Rails.application.routes.draw do
  resources :favorites, only: [:create, :destroy]
  resources :users
  resources :sessions, only: [:new, :create, :destroy]
  get '/users/:id/favorites', to: 'users#favorites'
  resources :pictures do
    collection do
      post :confirm
    end
  end
  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?
end
