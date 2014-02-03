json.extract! @workload, :id, :start_at, :end_at, :user_id
json.issue do
  json.partial! 'issues/issue', issue: @issue
end
if @prev_issue
  json.prev_issue do
    json.partial! 'issues/issue', issue: @prev_issue
  end
end
