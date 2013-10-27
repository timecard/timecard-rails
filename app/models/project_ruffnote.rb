class ProjectRuffnote < Provider
  store_into :info do |a|
    full_name 
  end


  def add_issue(token, params)
    fn = self.full_name.gsub(/  /,"").split("/")
    if params[:assignee_id].blank?
      assignee = nil
    else
      a = User.find(params[:assignee_id])
      assignee = a.ruffnote.username
    end
=begin
    issue = Provider.ruffnote(token).issues.create(
      fn[0], fn[1],
      title: params[:subject],
      body: params[:description],
      assignee: assignee
    )
=end
    fn = self.full_name
    Provider.ruffnote(token).post(
      "/api/v1/#{fn}/issues.json", 
      body: { 
        issue: { 
          title: params[:subject], 
          description: params[:description], 
          to_user: params[:assinee] 
        } 
      }
    )
  end
end
