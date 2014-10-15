class AddRoleToMembers < ActiveRecord::Migration
  def up
    add_column :members, :role, :integer, default: 0
    Member.where(is_admin: false).update_all(role: 2)
  end

  def down
    remove_column :members, :role
  end
end
