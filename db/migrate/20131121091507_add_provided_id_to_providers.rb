class AddProvidedIdToProviders < ActiveRecord::Migration
  def change
    add_column :providers, :provided_id, :integer
  end
end
