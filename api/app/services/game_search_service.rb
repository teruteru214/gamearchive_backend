# app/services/game_search_service.rb
class GameSearchService
  def initialize(search_terms)
    @search_terms = search_terms
  end

  def call
    conn = Faraday.new(url: 'https://api.igdb.com/v4/games') do |f|
      f.request :url_encoded
      f.response :json, content_type: /\bjson$/
      f.adapter Faraday.default_adapter
    end

    encoded_terms = @search_terms.split.map { |term| ERB::Util.url_encode(term) }.join(" ")

    response = conn.post do |req|
      req.headers['Client-ID'] = ENV['IGDB_CLIENT_ID']
      req.headers['Authorization'] = ENV['IGDB_AUTHORIZATION']
      req.headers['Accept-Language'] = 'ja'
      req.body = "fields id, name, cover.url, genres.name, platforms.name, url, rating; limit 150; search \"#{encoded_terms}\";"
    end

    if response.success?
      raw_games = response.body
      transform_to_game_objects(raw_games)
    else
      { error: 'Error retrieving games' }
    end
  end

  private

  def transform_to_game_objects(raw_games)
    raw_games.map do |game|
      cover_url = game.dig('cover', 'url')
      cover_big_url = cover_url ? "https://images.igdb.com/igdb/image/upload/t_cover_big/#{cover_url.split('/').last}" : nil
      rating = game.dig('rating')
      rounded_rating = rating ? rating.floor : nil
      {
        title: game['name'],
        cover: cover_big_url,
        rating: rounded_rating,
        url: game['url'],
        genres: (game['genres'] || []).map { |genre| genre['name'] },
        platforms: (game['platforms'] || []).map { |platform| platform['name'] }
      }
    end
  end
end
