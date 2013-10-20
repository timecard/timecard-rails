class CreateMembers < ActiveRecord::Migration
  def change
    create_table :members do |t|
      t.integer :user_id, default: 0, null: false
      t.integer :project_id, default: 0, null: false
      t.boolean :is_admin, default: false, null: false

      t.timestamps
    end
  end
end
