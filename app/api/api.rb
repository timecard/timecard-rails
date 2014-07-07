class API < Grape::API
  prefix "api"
  version "v1", using: :header, vendor: "timecard"
  format :json
  formatter :json, Grape::Formatter::Jbuilder

  helpers do
    def warden
      env['warden']
    end

    def authenticated!
      if warden.authenticated?
        true
      else
        error!("401 Unauthorized", 401)
      end
    end

    def current_user
      warden.user
    end
  end

  namespace :my do
    resource :projects do
      desc "Return all my projects"
      get "", jbuilder: "projects" do
        authenticated!
        @projects = Project.visible(current_user)
      end

      route_param :id do
        params do
          optional :status, type: String, default: "open"
        end

        get "issues", jbuilder: "issues" do
          authenticated!
          project = Project.find(params[:id])
          @issues = project.issues.with_status(params[:status]).where("assignee_id = ?", current_user.id)
        end
      end

      get :comments, jbuilder: "comments" do
        @comments = PublicActivity::Activity.where(owner_id: Project.visible(current_user), owner_type: "Project").order("created_at DESC").map { |activity| activity.trackable }
      end
    end

    resource :issues do
      params do
        optional :status, type: String, default: "open"
      end
      desc "Return all my issues"
      get "", jbuilder: "issues" do
        authenticated!
        @current_user = current_user
        @issues = current_user.issues.with_status(params[:status])
      end
    end

    resource :workloads do
      desc "Return latest my workloads"
      get "latest", jbuilder: "workloads" do
        authenticated!
        @workloads = current_user.workloads.order("updated_at DESC").limit(10)
      end
    end
  end
end
