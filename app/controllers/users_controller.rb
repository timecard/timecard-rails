class UsersController < ApplicationController
  before_action :authenticate_user!

  def show
    @user = User.find(params[:id])
    @workloads = @user.workloads.complete.where("start_at >= ? AND start_at <= ?", Time.now.beginning_of_day, Time.now.end_of_day)
    respond_to do |format|
      format.html
    end
  end

  def disconnect
    current_user.authentications.where(provider: params[:provider]).first.destroy
    flash[:notice] = "Disconnect from #{params[:provider].titleize}"
    redirect_to edit_user_registration_path
  end
end
