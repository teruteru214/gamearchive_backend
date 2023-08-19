class Game < ApplicationRecord
  belongs_to :user
  has_one :game_status, dependent: :destroy
  has_one :favorite, dependent: :destroy
  has_many :game_genres, dependent: :destroy
  has_many :genres, through: :game_genres
  has_many :game_platforms, dependent: :destroy
  has_many :platforms, through: :game_platforms

  validates :title, presence: true, uniqueness: { scope: :user_id, message: "You have already added this game" }
  validates :url, presence: true, format: { with: URI::DEFAULT_PARSER.make_regexp(%w[http https]) }
end
