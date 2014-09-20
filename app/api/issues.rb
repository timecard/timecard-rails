class Issues < Grape::API
  resource :issues do
    get ":id", jbuilder: "issue" do
      @issue = Issue.find(params[:id])
      authorize!(:read, @issue)
    end
  end
end
