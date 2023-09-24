Rails.application.routes.draw do
  namespace :api, format: "json" do
    namespace :v1 do
      resource :authentication, only: %w[create]
      resource :image, only: %w[create show]
      resource :profile, only: %w[show update]
      get '/search', to: 'search#search'
      resources :games, only: %w[index create destroy] do
        collection do
          get 'favorites', to: 'games#favorites'
        end
      end
      resources :game_statuses, only: %w[update]
      resources :favorites, only: %w[create destroy]
      resource :line_settings, only: %w[create update]
      get '/line_setting', to: 'line_settings#show'
    end
  end
end
