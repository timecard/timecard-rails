class TimeEntries < Grape::API
  namespace :user do
    resource :time_entries do
      get "", jbuilder: "time_entries" do
        @time_entries = current_user.time_entries
                                    .page(params[:page])
                                    .per(params[:per_page])
      end
    end
  end
end
