class GameStatusSerializer
  include JSONAPI::Serializer
  attributes :id, :status

  belongs_to :game
  belongs_to :user
end
