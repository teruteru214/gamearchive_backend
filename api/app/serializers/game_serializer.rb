class GameSerializer
  include JSONAPI::Serializer
  attributes :id, :title, :cover, :rating, :url

  attribute :game_status do |game|
    game.game_status.attributes.slice('id', 'status')
  end

  attribute :game_genres do |game|
    game.genres.map do |genre|
      { id: genre.id, name: genre.name }
    end
  end

  attribute :game_platforms do |game|
    game.platforms.map do |platform|
      { id: platform.id, name: platform.name }
    end
  end
end
