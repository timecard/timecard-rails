class RenameWorkLogsToWorkloads < ActiveRecord::Migration
  def change
    rename_table :work_logs, :workloads
  end
end
