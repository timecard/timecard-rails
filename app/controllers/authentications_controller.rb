class AuthenticationsController < ApplicationController
  before_action :authenticate_user!

  def index
    @authentications = current_user.authentications
  end

  def new
    @select_list = current_user.selectable_providers
    @authentication = Authentication.new
  end

  def create
    @authentication = current_user.authentications.build(authentication_params)
    if @authentication.save
      redirect_to edit_user_registration_path
    else
      render 'new'
    end
  end

  def destroy
    @authentication = current_user.authentications.find(params[:id])
    @authentication.destroy
    redirect_to edit_user_registration_path
  end

  private
    def authentication_params
      params.require(:authentication).permit(:user_id, :provider, :username)
    end
end
