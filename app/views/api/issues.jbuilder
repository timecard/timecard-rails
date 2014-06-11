json.array! @issues do |issue|
  json.partial! "issue", issue: issue
end
