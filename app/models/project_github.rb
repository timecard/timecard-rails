class ProjectGithub < Provider
  store_into :info do |a|
    full_name
  end

  def add_issue(token, params)
    fn = self.full_name.split("/")
    if params[:assignee_id].blank?
      assignee = nil
    else
      a = User.find(params[:assignee_id])
      assignee = a.github.username
    end
    labels = []
    unless params[:github_labels].blank?
      params[:github_labels].each do |key, value|
        labels << value
      end
    end
    issue = Provider.github(token).issues.create(
      fn[0], fn[1],
      title: params[:subject],
      body: params[:description],
      assignee: assignee,
      labels: labels
    )
  end
end
