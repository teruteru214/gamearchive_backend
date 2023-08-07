class Api::V1::GamesController < Api::V1::BaseController
  def index
    if params[:status]
      @games = current_user.games.includes(:game_status, :game_genres, :game_platforms).where(game_status: {status: params[:status]})
    else
      @games = current_user.games.includes(:game_status, :game_genres, :game_platforms)
    end

    render json: serialize_games(@games)
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
