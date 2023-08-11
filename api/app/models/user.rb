class User < ApplicationRecord
  has_many :games, dependent: :destroy
  has_many :game_statuses, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :favorited_games, through: :favorites, source: :game

  validates :nickname,    presence: true, length: { maximum: 40 }
  validates :uid,         presence:true, uniqueness: true
  validates :introduction, length: { maximum: 160 }
  validates :visibility,  inclusion: { in: %w(private public), message: "%{value} is not a valid visibility" }

  def self.find_or_create_user(user_info)
    user = User.find_by(uid: user_info[:uid])

    if user
      return { user: user, is_new: false }
    else
      new_user = User.create!(uid: user_info[:uid], nickname: user_info[:nickname], visibility: "private")
      return { user: new_user, is_new: true }
    end
  end

  def favorite(game)
    favorited_games << game
  end

  def unfavorite(game)
    favorited_games.destroy(game)
  end
end
