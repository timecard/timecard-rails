json.extract! issue, :id, :subject, :description, :will_start_at, :status, :closed_on, :project_id, :created_at, :updated_at
json.user issue.author
json.assignee issue.assignee if issue.assignee
json.provider issue.provider if issue.provider

json.is_do_today issue.do_today?
json.is_running (current_user.work_in_progress?(issue))
if current_user.work_in_progress?(issue)
  json.running_workload_id current_user.running_workload.id
end
if Project.where(id: issue.project_id).first.crowdworks_url.blank? || current_user.authentications.where(provider: "crowdworks").blank?
  json.is_crowdworks false
else
  json.is_crowdworks true
end
