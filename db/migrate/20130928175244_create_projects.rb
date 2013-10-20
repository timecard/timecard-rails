class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string :name, default: "", null: false
      t.text :description
      t.boolean :is_public, default: true, null: false
      t.integer :parent_id
      t.integer :status, default: 1, null: false

      t.timestamps
    end
  end
end
