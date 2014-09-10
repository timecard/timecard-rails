class IssueGithub < Provider
  default_scope { where(provided_type: "Issue") }

  belongs_to :issue, foreign_key: :foreign_id

  store_into :info do |a|
    issue_id
    html_url
    number
    assignee_avatar_url 
    labels
  end
end
