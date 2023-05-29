Rails.application.routes.draw do
  get 'sessions/create'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  options '/api/login', to: 'sessions#create'
  post '/api/login', to: 'sessions#create'
end
