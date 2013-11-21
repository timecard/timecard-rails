class RenameColumToProviders < ActiveRecord::Migration
  def change
    rename_column :providers, :provided_id, :foreign_id
  end
end
