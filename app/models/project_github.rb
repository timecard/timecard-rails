class ProjectGithub < Provider
  store_into :info do |a|
    id
    full_name
  end

  def add_issue(params)
    fn = self.full_name.split("/")
    assignee = nil #TODO
    issue = Provider.github.issues.create(
      fn[0], fn[1],
      title: params[:subject],
      body: params[:description],
      assignee: assignee
    )
  end
end
