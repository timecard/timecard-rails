json.extract! issue, :id, :subject, :description, :will_start_at, :status, :closed_on, :project_id, :author_id, :assignee_id, :created_at, :updated_at
json.author_name issue.author.name
json.humalized_created_at "#{time_ago_in_words(issue.created_at)} ago"
json.provider_number provider_number(issue)
json.provider_url provider_url(issue)
json.is_do_today issue.do_today?
json.is_running (current_user.work_in_progress?(issue))
if current_user.work_in_progress?(issue)
  json.running_workload_id current_user.running_workload.id
end
if Project.where(id: issue.project_id).first.crowdworks_url.empty? or current_user.authentications.where(provider: "crowdworks").blank?
  json.is_crowdworks false
else
  json.is_crowdworks true
end
