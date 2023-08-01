Rails.application.routes.draw do
  namespace :api, format: "json" do
    namespace :v1 do
      resources :hello, only: %w[index]
      resource :authentication, only: %w[create]
      resource :image, only: %w[create show]
      resource :profile, only: %w[show update]
      post '/search', to: 'search#search'
      resources :games, only: [:create]
      resources :game_statuses, only: [:create]
    end
  end
end
