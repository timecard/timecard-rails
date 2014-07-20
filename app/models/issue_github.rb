class IssueGithub < Provider
  store_into :info do |a|
    issue_id
    html_url
    number
    assignee_avatar_url 
    labels
  end

  def issue
    Issue.find(self.foreign_id)
  end
end
