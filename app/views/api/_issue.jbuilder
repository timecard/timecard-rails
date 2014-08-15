json.extract! issue, :id, :subject, :description, :will_start_at, :status, :closed_on, :project_id, :created_at, :updated_at
json.project issue.project
json.user issue.author
json.assignee issue.assignee if issue.assignee
json.provider issue.provider if issue.provider
json.comments issue.comments

json.is_do_today issue.do_today?
json.is_running current_user.time_tracking?(issue)
if current_user.time_tracking?(issue)
  json.running_workload_id current_user.current_entry.id
end

if current_user.authentications.exists?(["provider = ?", "crowdworks"]) && issue.project.crowdworks_contracts.exists?(["user_id = ?", current_user.id])
  json.is_crowdworks true
else
  json.is_crowdworks false
end
