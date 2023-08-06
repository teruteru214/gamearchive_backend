class Api::V1::GameStatusesController < Api::V1::BaseController
  before_action :set_game_status, only: [:update]

  def update
    if @game_status.update(game_status_params)
      json_string = GameStatusSerializer.new(@game_status).serializable_hash.to_json
      render json: json_string
    else
      render json: { errors: @game_status.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def set_game_status
    @game_status = current_user.game_statuses.find(params[:id])
  end

  def game_status_params
    params.require(:game_status).permit(:status)
  end
end
