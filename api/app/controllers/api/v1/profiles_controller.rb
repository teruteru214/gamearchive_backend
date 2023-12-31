class Api::V1::ProfilesController < Api::V1::BaseController
  def update
    if current_user.update(profile_params)
      json_string = UserSerializer.new(current_user).serializable_hash.to_json
      render json: json_string
    else
      render_500(nil, current_user.errors.full_messages)
    end
  end

  def show
    json_string = UserSerializer.new(current_user).serializable_hash.to_json
    render json: json_string
  end

  private

  def profile_params
    params.require(:profile).permit(:nickname, :introduction, :avatar_key, :twitter_name, :visibility)
  end

end
