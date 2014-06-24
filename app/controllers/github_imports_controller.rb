class GithubImportsController < ApplicationController
  def create
    @project = Project.find(params[:project_id])

    respond_to do |format|
      if GithubImporter.new(@project).import_issues
        format.html { redirect_to @project, notice: "Synchronization with the Github has been completed." }
      else
        format.html { redirect_to @project, alert: "Synchronization with the Github has been failed." }
      end
    end
  end
end
