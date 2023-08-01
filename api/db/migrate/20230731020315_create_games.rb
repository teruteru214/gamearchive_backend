class CreateGames < ActiveRecord::Migration[6.1]
  def change
    create_table :games do |t|
      t.references :user, null: false, foreign_key: true
      t.string :title, null: false
      t.string :cover
      t.integer :rating
      t.string :url, null: false

      t.timestamps
    end
    add_index :games, [:user_id, :title], unique: true
  end
end
