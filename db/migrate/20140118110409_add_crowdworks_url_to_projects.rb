class AddCrowdworksUrlToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :crowdworks_url, :text
  end
end
