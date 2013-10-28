class HomeController < ApplicationController
  def index
    if user_signed_in?
      status = params[:status] || 1
      @issues = current_user.issues_with_status(status)
    end
  end
end
