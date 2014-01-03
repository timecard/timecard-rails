class HomeController < ApplicationController
  def index
    if user_signed_in?
      public_projects = Project.public.active.where_values.reduce(:and)
      my_projects = Project.active.visible(current_user).where_values.reduce(:and)
      @projects = Project.where(public_projects.or(my_projects)).
      select("projects.*, count(issues.id) AS issues_count").
      joins(:issues).
      where("issues.assignee_id = #{current_user.id}").
      group("projects.id")
    else
      render 'welcome'
    end
  end
end
