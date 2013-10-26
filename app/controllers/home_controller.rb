class HomeController < ApplicationController
  def index
    if user_signed_in?
      status = params[:status] || 1
      @issues = current_user.issues.where("status = ?", status).order("updated_at DESC")
    end
  end
end
