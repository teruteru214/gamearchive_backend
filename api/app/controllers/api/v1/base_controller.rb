class Api::V1::BaseController < ApplicationController
  include Api::ErrorRenderable
  include FirebaseAuth
  include ActionController::HttpAuthentication::Token::ControllerMethods

  before_action :authenticate

  def authenticate
    authenticate_with_http_token do |token, _options|
      result = verify_id_token(token)

      if result[:errors]
        render_400(nil, result[:errors])
      else
        user_result = User.find_or_create_user(result)
        @_current_user = user_result[:user]
      end
    end
  end

  def current_user
    @_current_user
  end
end
