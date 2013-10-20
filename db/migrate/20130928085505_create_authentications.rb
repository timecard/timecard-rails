class CreateAuthentications < ActiveRecord::Migration
  def change
    create_table :authentications do |t|
      t.integer :user_id, default: 0, null: false
      t.string :provider, default: "", null: false
      t.integer :uid, default: 0, null: false
      t.string :username, default: "", null: false
      t.string :oauth_token, default: "", null: false

      t.timestamps
    end
  end
end
