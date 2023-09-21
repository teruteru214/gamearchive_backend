class CreateLineSettings < ActiveRecord::Migration[6.1]
  def change
    create_table :line_settings do |t|
      t.references :user, null: false, foreign_key: true
      t.string :line_user_id, null: false
      t.boolean :line_notification, default: false
      t.integer :stacked_notification_interval, default: 30
      t.integer :favorite_notification_interval, default: 30

      t.timestamps
    end

    add_index :line_settings, [:line_user_id], unique: true
  end
end
