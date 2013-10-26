class ProjectGithub < Provider
  store_into :info do |a|
    id
    full_name
  end

  def add_issue(params)
    fn = self.full_name.gsub(/  /,"").split("/")
    assignee = nil #TODO 担当者の指定をgithubと動機する機能はまだ未実装
    issue = Provider.github.issues.create(
      fn[0], fn[1],
      title: params[:subject],
      body: params[:description],
      assignee: assignee
    )
  end
end
