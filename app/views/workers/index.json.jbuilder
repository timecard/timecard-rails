json.array! @workers do |worker|
  json.extract! worker, :id, :name, :email
  json.project worker.working_issue.project
  json.issue do
    json.partial! 'issues/issue', issue: worker.working_issue
  end
  json.workload worker.running_workload
end
