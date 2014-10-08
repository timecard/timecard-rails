class UsersController < ApplicationController
  before_action :authenticate_user!, only: [:show]

  def show
    @user = User.find(params[:id])
  end

  def disconnect
    current_user.authentications.find_by(provider: params[:provider]).destroy
    flash[:notice] = "Disconnect from #{params[:provider].titleize}"
    redirect_to edit_user_registration_url
  end
end
