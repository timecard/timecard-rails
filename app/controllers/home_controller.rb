class HomeController < ApplicationController
  def index
    if user_signed_in?
      status = params[:status] || 1
      @issues = current_user.issues.where("status = ?", status).where("will_start_at is null or will_start_at < ?", Time.now).order("updated_at DESC") #TODO Issueモデルでscope設定するのが望ましい
    end
  end
end
