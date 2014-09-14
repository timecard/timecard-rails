class TimeEntries < Grape::API
  namespace :user do
    resource :time_entries do
      get "", jbuilder: "time_entries" do
        @time_entries = current_user.time_entries
                                    .page(params[:page])
                                    .per(params[:per_page])
      end
    end

    resource :issues do
      route_param :issue_id do
        resource :time_entries do
          get "", jbuilder: "time_entries" do
            @issue = Issue.find(params[:issue_id])
            @time_entries = current_user.time_entries
                                        .where(issue: @issue)
                                        .page(params[:page])
                                        .per(params[:per_page])
          end
        end
      end
    end
  end
end
