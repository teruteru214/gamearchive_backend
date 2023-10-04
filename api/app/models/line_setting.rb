class LineSetting < ApplicationRecord
  belongs_to :user

  validates :line_user_id, presence: true, uniqueness: true
  validates :stacked_notification_interval, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 60 }

  before_create :set_initial_notification_date
  before_update :reset_notification_date_if_interval_changed, if: :stacked_notification_interval_changed?


  def notify_stacked_game
    game = random_stacked_game
    if game
      line_message_service = LineStackedGameService.new(user, game)
      flex_contents = line_message_service.generate_flex_message
      line_client = LineClient.new
      begin
        line_client.push_flex_message(line_user_id, "積みゲーそろそろプレイしませんか？", flex_contents)
      rescue => e
        Rails.logger.error "Failed to send message: #{e.message}"
      end
    end
  end

  def random_stacked_game
    stacked_games = user.games.joins(:game_status).where(game_status: { status: 'unplaying' })
    stacked_games.order("RANDOM()").first
  end

  def self.notify_users
    LineSetting.where(line_notification: true).where(notification_date: Date.today).find_each do |line_setting|
      line_setting.notify_stacked_game
      line_setting.update!(notification_date: Date.today + line_setting.stacked_notification_interval.days)
    end
  end

  private

  def set_initial_notification_date
    self.notification_date = Date.today + stacked_notification_interval.days
  end

  def reset_notification_date_if_interval_changed
    self.notification_date = Date.today + stacked_notification_interval.days
  end
end
