class HomeController < ApplicationController
  def index
    if user_signed_in?
      @projects = Project.active.select("projects.*, count(issues.id) AS issues_count").
      joins(:issues).
      where("issues.assignee_id = #{current_user.id}").
      where("issues.status = 1").
      group("projects.id")
    else
      render 'welcome'
    end
  end
end
