class GameGenreSerializer
  include JSONAPI::Serializer
  attributes :id

  belongs_to :game
  belongs_to :genre
end
