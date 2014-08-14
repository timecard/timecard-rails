class ApplicationController < ActionController::Base
  include PublicActivity::StoreController

  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.html { redirect_to root_url, :alert => exception.message }
      format.json { render json: [], status: :unauthorized }
    end
  end

  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_current_user, if: :user_signed_in?
  helper_method :current_user_time_tracking?
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) do |u|
      u.permit(:name, :email, :password, :password_confirmation)
    end
    devise_parameter_sanitizer.for(:account_update) do |u|
      u.permit(:name, :email, :password, :password_confirmation)
    end
  end

  private

  def current_user_time_tracking?
    return false unless user_signed_in?
    current_user.time_tracking?
  end

  def set_current_user
    User.current = current_user
  end
end
