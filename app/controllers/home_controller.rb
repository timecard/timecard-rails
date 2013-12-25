class HomeController < ApplicationController
  def index
    if user_signed_in?
      public_projects = Project.public.active.where_values.reduce(:and)
      my_projects = Project.active.visible(current_user).where_values.reduce(:and)
      @projects = Project.where(public_projects.or(my_projects))
      @issues = Issue.with_status("open").where("assignee_id = ?", current_user.id)
    else
      render 'welcome'
    end
  end
end
