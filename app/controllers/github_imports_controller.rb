class GithubImportsController < ApplicationController
  def create
    @project = Project.find(params[:project_id])

    if GithubImporter.new(@project).import_issues
      redirect_to @project, notice: "Synchronization with the Github has been completed."
    else
      redirect_to @project, alert: "Synchronization with the Github has been failed."
    end
  end
end
