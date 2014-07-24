class ReportsController < ApplicationController
  before_action :authenticate_user!

  def index
    @workloads = current_user.workloads
      .complete.daily
  end
end
