class GameCreationService
  def initialize(user, game_params, game_status_params, genres, platforms)
    @user = user
    @game_params = game_params
    @game_status_params = game_status_params
    @genres = genres
    @platforms = platforms
  end

  def call
    game = @user.games.new(@game_params)

    ActiveRecord::Base.transaction do
      game.save!
      create_game_status(game)
      create_game_genres(game) if @genres
      create_game_platforms(game) if @platforms
    end

    game
  end

  private

  def create_game_status(game)
    game_status = game.build_game_status(@game_status_params.merge(user: @user))
    game_status.save!
  end

  def create_game_genres(game)
    @genres.each do |genre_name|
      genre = Genre.find_or_create_by!(name: genre_name)
      game.game_genres.create!(genre: genre)
    end
  end

  def create_game_platforms(game)
    @platforms.each do |platform_name|
      platform = Platform.find_or_create_by!(name: platform_name)
      game.game_platforms.create!(platform: platform)
    end
  end
end
