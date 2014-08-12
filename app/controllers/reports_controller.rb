class ReportsController < ApplicationController
  before_action :authenticate_user!

  def index
    if params[:user_id]
      user_index
    end
  end

  def user_index
    @user = User.find(params[:user_id])
    @workloads = current_user.workloads
      .complete.daily
    render "user_index"
  end
end
