class ProjectGithub < Provider
  store_into :info do |a|
    id
    full_name
  end

  def add_issue(token, params)
    fn = self.full_name.gsub(/  /,"").split("/")
    a = User.find(params[:assignee_id])
    assignee = a.github ? a.github.username : nil
    issue = Provider.github(token).issues.create(
      fn[0], fn[1],
      title: params[:subject],
      body: params[:description],
      assignee: assignee
    )
  end
end
