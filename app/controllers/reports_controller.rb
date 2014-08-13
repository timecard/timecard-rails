class ReportsController < ApplicationController
  before_action :authenticate_user!

  def index
    if params[:user_id]
      user_index
    elsif params[:project_id]
      project_index
    end
  end

  def user_index
    @user = User.find(params[:user_id])
    authorize! :report, @user
    @workloads = current_user.workloads
      .complete.daily
    render "user_index"
  end

  def project_index
    @project = Project.find(params[:project_id])
    today = params[:date].present? ? Date.parse(params[:date]) : Time.zone.today
    @week = today.beginning_of_week..today.end_of_week
    authorize! :report, @project

    respond_to do |format|
      format.html { render "project_index" }
      format.json
    end
  end
end
