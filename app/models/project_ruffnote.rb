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
    fn = self.full_name
    Provider.ruffnote(token).post(
      "/api/v1/#{fn}/issues.json", 
      body: { 
        issue: { 
          title: params[:subject], 
          description: params[:description], 
          to_user: assignee
        }
      }
    )
  end
end
