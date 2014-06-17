json.extract! issue, :id, :subject, :description, :will_start_at, :status, :closed_on, :created_at, :updated_at
json.project issue.project
json.user issue.author
json.assignee issue.assignee if issue.assignee
json.provider issue.provider if issue.provider

json.is_do_today issue.do_today?
json.is_running (current_user.work_in_progress?(issue))
if current_user.work_in_progress?(issue)
  json.running_workload_id current_user.running_workload.id
end

if current_user.authentications.exists?(["provider = ?", "crowdworks"]) && issue.project.crowdworks_contracts.exists?(["user_id = ?", current_user.id])
  json.is_crowdworks true
else
  json.is_crowdworks false
end
