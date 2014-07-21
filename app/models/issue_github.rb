class IssueGithub < Provider
  belongs_to :issue, foreign_key: :foreign_id

  store_into :info do |a|
    issue_id
    html_url
    number
    assignee_avatar_url 
    labels
  end
end
