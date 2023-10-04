class AddNotificationDateToLineSetting < ActiveRecord::Migration[6.1]
  def change
    add_column :line_settings, :notification_date, :datetime
  end
end
