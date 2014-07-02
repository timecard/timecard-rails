json.total_pages @issues.total_pages
json.current_page @issues.current_page
json.issues @issues do |issue|
  json.partial! "issue", issue: issue
end
