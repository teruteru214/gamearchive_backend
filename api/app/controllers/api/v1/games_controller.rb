class Api::V1::GamesController < Api::V1::BaseController
  def create
    game = current_user.games.new(game_params)

    ActiveRecord::Base.transaction do
      game.save!
      create_game_status(game)
      create_game_genres(game) if params[:genres]
      create_game_platforms(game) if params[:platforms]
    end

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

  def create_game_status(game)
    game_status = game.build_game_status(game_status_params)
    game_status.user = current_user
    game_status.save!
  end

  def create_game_genres(game)
    genres_params.each do |genre_name|
      genre = Genre.find_or_create_by!(name: genre_name)
      game.game_genres.create!(genre: genre)
    end
  end

  def create_game_platforms(game)
    platforms_params.each do |platform_name|
      platform = Platform.find_or_create_by!(name: platform_name)
      game.game_platforms.create!(platform: platform)
    end
  end
end
