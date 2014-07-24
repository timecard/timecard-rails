class ReportsController < ApplicationController
  before_action :authenticate_user!

  def index
    @workloads = current_user.workloads
      .complete.where("start_at >= ? AND start_at <= ?", Time.now.beginning_of_day, Time.now.end_of_day)
  end
end
