class TimeEntries < Grape::API
  namespace :user do
    resource :time_entries do
      # /api/user/time_entries
      desc "Return time entries of user"
      get do
        authenticated!
        @time_entries = current_user.workloads
                                    .page(params[:page])
                                    .per(params[:per])
      end
    end
  end
end
