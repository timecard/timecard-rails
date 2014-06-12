json.array! @workloads do |workload|
  json.extract! workload, :id, :start_at, :end_at, :created_at, :updated_at
  json.issue do
    json.partial! "issue", issue: workload.issue
  end
end
