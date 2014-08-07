json.total_pages @issues.total_pages
json.issues @issues do |issue|
  json.partial! "issue", issue: issue
end
