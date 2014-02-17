json.array!(@projects) do |project|
  json.extract! project, :id, :name, :description, :is_public, :parent_id, :status
  json.open_issues_count project.issues.open.count
  json.closed_issues_count project.issues.closed.count
  json.members project.members do |member|
    json.extract! member.user, :id, :name, :email
    json.avatar_url gravatar_url(member.user.email)
  end
  json.url project_url(project, format: :json)
end
