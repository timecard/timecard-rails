class UsersController < ApplicationController
  def disconnect
    current_user.authentications.where(provider: params[:provider]).first.destroy
    flash[:notice] = "Disconnect from #{params[:provider].titleize}"
    redirect_to edit_user_registration_path
  end
end
