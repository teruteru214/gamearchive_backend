class LineSettingsController < Api::V1::BaseController
  def create
    unless current_user
      render json: { error: 'User not authenticated' }, status: :unauthorized
      return
    end

    channel_id = ENV["LIFF_CHANNEL_ID"]
    get_liff_user_service = GetLiffUserService.new(params[:lineIdToken], channel_id)
    result = get_liff_user_service.call

    unless result[:status] == :ok
      render json: { error: result[:error] }, status: result[:status]
      return
    end

    line_user_id = result[:line_user_id]

    line_setting = LineSetting.find_or_create_by!(line_user_id: line_user_id, user: current_user)
    render json: LineSettingSerializer.new(line_setting).serializable_hash.to_json, status: :created
  end


  def show
    line_setting = current_user.line_setting

    if line_setting
      render json: LineSettingSerializer.new(line_setting).serializable_hash.to_json, status: :ok
    else
      render json: { error: 'LineSetting not found' }, status: :not_found
    end
  end

  private

  def line_setting_params
    params.require(:line_setting).permit(:line_user_id, :line_notification, :stacked_notification_interval, :favorite_notification_interval)
  end
end
