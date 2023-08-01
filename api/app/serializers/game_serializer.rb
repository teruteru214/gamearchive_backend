class GameSerializer
  include JSONAPI::Serializer
  attributes :id, :title, :cover, :rating, :url

  has_one :game_status, serializer: GameStatusSerializer
  has_many :game_genres, serializer: GameGenreSerializer
  has_many :game_platforms, serializer: GamePlatformSerializer
end
