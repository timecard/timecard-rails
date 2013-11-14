class HomeController < ApplicationController
  before_action :authenticate_user!

  def index
    status = params[:status] || "open"
    @issues = current_user.issues.with_status(status)
  end
end
