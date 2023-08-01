class GamePlatformSerializer
  include JSONAPI::Serializer
  attributes :id

  belongs_to :game
  belongs_to :platform
end
