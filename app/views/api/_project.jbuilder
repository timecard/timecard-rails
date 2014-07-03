json.extract! project, :id, :name, :description, :is_public, :parent_id, :status, :created_at, :updated_at
json.open_issues_count project.issues.with_status("open").count
