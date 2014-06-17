class RemoveCrowdworksUrlFromProject < ActiveRecord::Migration
  def up
    remove_column :projects, :crowdworks_url
  end

  def down
    add_column :projects, :crowdworks_url, :text
  end
end
