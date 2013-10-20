class CreateProvider < ActiveRecord::Migration
  def change
    create_table(:providers) do |t|
      t.string :name
      t.integer :provided_id
      t.string :provided_type
      t.text :info, {:limit => 16777215}
    end
  end
end
