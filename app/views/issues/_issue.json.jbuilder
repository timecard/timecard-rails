json.extract! issue, :id, :subject, :description, :will_start_at, :status, :closed_on, :project_id, :author_id, :assignee_id, :created_at, :updated_at
json.author_name issue.author.name
json.humalized_created_at "#{time_ago_in_words(issue.created_at)} ago"
json.provider_number provider_number(issue)
json.provider_url provider_url(issue)
json.is_do_today issue.do_today?
json.is_running (current_user.workloads.running && current_user.workloads.running.issue == issue)
if (current_user.workloads.running && current_user.workloads.running.issue == issue)
  json.running_workload_id current_user.workloads.running.id
end
