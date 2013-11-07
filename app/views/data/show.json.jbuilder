json.extract! @project, :name, :description

json.issues @project.issues do |issue|
  json.(issue, :subject, :description)
  json.author_email issue.author.email
  json.created_at issue.created_at.to_i
  json.updated_at issue.updated_at.to_i

  json.workloads issue.workloads do |workload|
    json.start_at workload.start_at.to_i
    json.end_at workload.end_at.to_i
    json.user_email workload.user.email
  end

  json.comments issue.comments do |comment|
    json.body comment.body
    json.user_email comment.user.email
  end
end
