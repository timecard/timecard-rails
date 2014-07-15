json.extract! project, :id, :name, :description, :is_public, :parent_id, :status, :created_at, :updated_at
if @user
  json.open_issues_count project.issues.with_status("open").where("assignee_id = ?", @user.id).count
else
  json.open_issues_count project.issues.with_status("open").count
end
