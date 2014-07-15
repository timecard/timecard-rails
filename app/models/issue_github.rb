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

  def add_comment(token, params)
    fn = self.issue.project.github.full_name.split("/")
    comment = Provider.github(token).issues.comments.create(
      fn[0], fn[1], self.number, body: params[:body]
    )
    return comment.body
  end
end
