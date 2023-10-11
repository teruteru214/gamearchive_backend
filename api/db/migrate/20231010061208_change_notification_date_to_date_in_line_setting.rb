class ChangeNotificationDateToDateInLineSetting < ActiveRecord::Migration[6.1]
  def change
    change_column :line_settings, :notification_date, :date
  end
end
