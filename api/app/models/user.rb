class User < ApplicationRecord
  validates :nickname,    presence: true, length: { maximum: 40 }
  validates :uid,         uniqueness: true
  validates :avatar_key,  uniqueness: true
  validates :introduction, length: { maximum: 160 }
  validates :visibility,  inclusion: { in: %w(private public), message: "%{value} is not a valid visibility" }
end
