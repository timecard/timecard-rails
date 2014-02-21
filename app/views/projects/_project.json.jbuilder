json.extract! project, :id, :name, :is_public, :parent_id, :status, :created_at, :updated_at
json.description markdown(project.description)
json.open_issues_count project.issues.open.count
json.closed_issues_count project.issues.closed.count
json.repo project.github ? project.github.full_name : ""
json.is_member current_user.present? ? project.member?(current_user) : false
json.members project.members do |member|
  json.extract! member.user, :id, :name, :email
  json.avatar_url gravatar_url(member.user.email)
end
json.url project_url(project, format: :json)
