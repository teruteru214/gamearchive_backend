class RemoveFavoriteNotificationIntervalFromLineSettings < ActiveRecord::Migration[6.1]
  def change
    remove_column :line_settings, :favorite_notification_interval, :integer
  end
end
