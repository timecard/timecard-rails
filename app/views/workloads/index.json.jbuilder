json.array! @workloads do |workload|
  json.extract! workload, :id, :start_at, :end_at
  json.project workload.issue.project
  json.issue workload.issue
end
