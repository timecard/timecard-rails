class CreateCrowdworksContracts < ActiveRecord::Migration
  def change
    create_table :crowdworks_contracts do |t|
      t.integer :user_id, null: false
      t.integer :project_id, null: false
      t.integer :contract_id, null: false

      t.timestamps
    end
  end
end
