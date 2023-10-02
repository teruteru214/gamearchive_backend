class LineSetting < ApplicationRecord
  belongs_to :user

  validates :line_user_id, presence: true, uniqueness: true
  validates :stacked_notification_interval, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 60 }
end
