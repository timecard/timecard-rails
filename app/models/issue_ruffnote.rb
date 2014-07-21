class IssueRuffnote < Provider
  belongs_to :issue, foreign_key: :foreign_id

  store_into :info do |a|
    number
    html_url
  end

  def reopen(token)
    modify(token, {state: false})
  end

  def close(token)
    modify(token, {state: true})
  end

  def modify(token, params)
    options = {}
    options["title"] = params[:subject] if params[:subject]
    options["description"] = params[:description] if params[:description]
    options["is_done"] = params[:state] unless params[:state].nil?
    if params[:assignee_id].present?
      user = User.find(params[:assignee_id])
      options["to_user"] = user.ruffnote.username
    else
      options["to_user"] = nil
    end
    fn = self.issue.project.ruffnote.full_name
    issue = Provider.ruffnote(token).put("/api/v1/#{fn}/issues/#{self.number}", body: { 
      issue: options
    }).parsed
  end

  def add_comment(token, params)
    fn = self.issue.project.ruffnote.full_name
    comment = Provider.ruffnote(token).post("/api/v1/#{fn}/issues/#{self.number}/comments", body: { 
      comment: {
        comment: params[:body]
      }
    }).parsed
  end

end
