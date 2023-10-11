class Api::V1::LineSettingsController < Api::V1::BaseController
  def create
    unless current_user

      render json: { error: 'User not authenticated' }, status: :unauthorized
      return
    end

    channel_id = ENV["LIFF_CHANNEL_ID"]
    get_liff_user_profile_service = GetLiffUserProfileService.new(params[:lineAccessToken], channel_id)
    result = get_liff_user_profile_service.call

    unless result[:status] == :ok
      render json: { error: result[:error] }, status: result[:status]
      return
    end

    line_user_id = result[:line_user_id]

    line_setting = LineSetting.find_or_create_by!(line_user_id: line_user_id, user: current_user)
    render json: LineSettingSerializer.new(line_setting).serializable_hash.to_json, status: :created
  end

  def show
    user = User.find_by(uid: params[:uid])

    unless user
      render json: { error: 'User not found' }, status: :not_found
      return
    end

    line_setting = user.line_setting

    if line_setting
      render json: LineSettingSerializer.new(line_setting).serializable_hash.to_json, status: :ok
    else
      render json: { error: 'LineSetting not found' }, status: :not_found
    end
  end

  def update
    line_setting = LineSetting.find(params[:id])

    unless line_setting && line_setting.user == current_user
      render json: { error: 'Not authorized' }, status: :forbidden
      return
    end

    if line_setting.update(line_setting_params)
      render json: LineSettingSerializer.new(line_setting).serializable_hash.to_json, status: :ok
    else
      render json: { error: line_setting.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def notification
    LineSetting.notify_users
    render json: { message: "Notifications sent successfully." }, status: :ok
  end

  private

  def line_setting_params
    params.require(:line_setting).permit(:line_notification, :stacked_notification_interval)
  end
end
