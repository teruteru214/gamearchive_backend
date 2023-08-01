class GameStatus < ApplicationRecord
  belongs_to :user
  belongs_to :game

  validates :status, presence: true, inclusion: { in: %w(unplaying playing clear), message: "%{value} is not a valid status" }
end
