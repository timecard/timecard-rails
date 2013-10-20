class CreateWorkLogs < ActiveRecord::Migration
  def change
    create_table :work_logs do |t|
      t.datetime :start_at
      t.datetime :end_at
      t.integer :issue_id, null: false
      t.integer :user_id, null: false

      t.timestamps
    end
  end
end
