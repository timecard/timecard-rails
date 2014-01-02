class DashboardsController < ApplicationController
  def show
    @workloads = current_user.workloads.complete.where("start_at >= ? AND start_at <= ?", Time.now.beginning_of_day, Time.now.end_of_day)
    respond_to do |format|
      format.html
    end
  end
end
