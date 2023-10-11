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
      resources :line_settings, only: %w[create update]
      get '/line_setting', to: 'line_settings#show'
      post '/line/callback', to: 'line_messages#callback'
      post '/line_setting/notification', to: 'line_settings#notification'
    end
  end
end
