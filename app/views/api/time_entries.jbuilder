json.array! @time_entries do |time_entry|
  json.extract! time_entry, :id, :start_at, :end_at, :created_at, :updated_at
  json.issue do
    json.partial! "issue", issue: time_entry.issue
  end
  json.user time_entry.user
end
