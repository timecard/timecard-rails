json.last_page @issues.last_page?
json.current_page @issues.current_page
json.issues @issues, partial: 'issues/issue', as: :issue
