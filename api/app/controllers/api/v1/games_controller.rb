class Api::V1::GamesController < Api::V1::BaseController
  def index
    @games = current_user.games.includes(:game_status, :genres, :platforms)
    render json: serialize_games(@games)
  end

  def favorites
    json_string = GameSerializer.new(current_user.favorited_games).serializable_hash.to_json
    render json: json_string
  end

  def create
    game = GameCreationService.new(
        current_user,
        game_params,
        game_status_params,
        genres_params,
        platforms_params
      ).call

      json_string = GameSerializer.new(game).serializable_hash.to_json
      render json: json_string, status: :created
    rescue ActiveRecord::RecordInvalid
      render json: { errors: game.errors.full_messages }, status: :unprocessable_entity
  end

  def destroy
    @game = current_user.games.find(params[:id])
    if @game.destroy
      render json: {status: :ok, message: "successfully game deleted!"}
    else
      render json: {status: :unprocessable_entity, message: @game.errors.full_messages.join(", ")}
    end
  end

  private

  def game_params
    params.require(:game).permit(:title, :cover, :rating, :url)
  end

  def game_status_params
    params.require(:game_status).permit(:status)
  end

  def genres_params
    params[:genres] || []
  end

  def platforms_params
    params[:platforms] || []
  end

  def serialize_games(games)
    GameSerializer.new(games).serializable_hash.to_json
  end
end
