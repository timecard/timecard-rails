class ProjectGithub < Provider
  store_into :info do |a|
    full_name
  end

  def add_issue(token, params)
    fn = self.full_name
    if params[:assignee_id].blank?
      assignee = nil
    else
      a = User.find(params[:assignee_id])
      assignee = a.github.username
    end
    issue = Provider.github(token).issues.create(
      fn[0], fn[1],
      title: params[:subject],
      body: params[:description],
      assignee: assignee
    )
  end
end
