class API < Grape::API
  prefix "api"
  version "v1", using: :header, vendor: "timecard"
  format :json

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
      get do
        authenticated!
        @projects = Project.visible(current_user)
      end
    end
  end
end
