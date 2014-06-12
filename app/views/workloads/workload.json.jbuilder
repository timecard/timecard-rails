json.extract! @workload, :id, :start_at, :end_at, :created_at, :updated_at
json.issue do
  json.partial! 'issues/issue', issue: @workload.issue
end

if @prev_issue
  json.prev_issue do
    json.partial! 'issues/issue', issue: @prev_issue
  end
end
