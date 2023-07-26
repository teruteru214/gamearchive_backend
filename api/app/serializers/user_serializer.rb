class UserSerializer
  include JSONAPI::Serializer
  attributes :nickname, :avatar_key, :introduction, :twitter_name, :visibility, :uid
end
