class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.string :nickname, null: false, limit: 40
      t.string :avatar_key
      t.string :uid, null: false
      t.string :introduction, limit: 160
      t.string :twitter_name
      t.string :visibility, null: false

      t.timestamps
    end

    add_index :users, [:uid], unique: true
  end
end
