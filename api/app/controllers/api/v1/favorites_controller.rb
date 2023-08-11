class Api::V1::FavoritesController < Api::V1::BaseController
  def create
    game = Game.find(params[:game_id])
    current_user.favorite(game)
    json_string = GameSerializer.new(game).serializable_hash.to_json
    render json: json_string
  end

  def destroy
    game = Game.find(params[:id])
    current_user.unfavorite(game)
    render json: { status: :ok }
  end
end
