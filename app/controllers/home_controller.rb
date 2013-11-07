class HomeController < ApplicationController
  def index
    if user_signed_in?
      status = params[:status] || "open"
      @issues = current_user.issues.with_status(status)
    end
  end
end
