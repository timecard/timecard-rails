class WorkersController < ApplicationController
  def index
    @workers = User.joins(:workloads).
      where("workloads.end_at IS NULL").
      order("workloads.start_at ASC")

    respond_to do |format|
      format.json { render 'index', status: :ok }
    end
  end
end
