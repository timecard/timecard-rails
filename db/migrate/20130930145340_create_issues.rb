class CreateIssues < ActiveRecord::Migration
  def change
    create_table :issues do |t|
      t.string :subject, default: "", null: false
      t.text :description
      t.datetime :will_start_at
      t.integer :status, default: 1, null: false
      t.datetime :closed_on
      t.integer :project_id, null: false
      t.integer :author_id, null: false
      t.integer :assignee_id

      t.timestamps
    end
  end
end
