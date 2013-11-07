class HomeController < ApplicationController
  def index
    if user_signed_in?
      status = params[:status] || 1
      @issues = current_user.issues.where("status = ?", status).do_today #TODO Issueモデルでscope設定するのが望ましい
    end
  end
end
