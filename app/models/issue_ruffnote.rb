class IssueRuffnote < Provider
  store_into :info do |a|
    issue_id
    number
    html_url
  end

  def issue
    Issue.find(self.foreign_id)
  end

  def modify(token, params)
    options = {}
    options["title"] = params[:subject] if params[:subject]
    options["body"] = params[:description] if params[:description]
    options["state"] = params[:state] if params[:state]
    if params[:assignee_id].present?
      user = User.find(params[:assignee_id])
      options["assignee"] = user.ruffnote.username
    else
      options["assignee"] = nil
    end
    fn = self.issue.project.ruffnote.full_name
=begin
    fn = self.issue.project.ruffnote.full_name.split("/")
    Provider.ruffnote(token).issues.edit(
      fn[0], fn[1], self.number, options
    )
=end
    Provider.ruffnote(token).put(
      "/api/v1/#{fn}/issues/#{self.number}.json", 
      body: { 
        issue: { 
          title: options['title'], 
          description: options['body'], 
          to_user: options['assignee']
        } 
      }
    )
  end
end
