json.extract! @workload, :id, :start_at, :end_at, :user_id
json.issue do
  json.partial! 'issues/issue', issue: @workload.issue
end
