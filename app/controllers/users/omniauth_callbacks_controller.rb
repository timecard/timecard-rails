class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def github
    omniauth = request.env["omniauth.auth"]
    authentication = Authentication.where(provider: omniauth.provider, uid: omniauth.uid).first
    if authentication.present?
      flash[:notice] = "Signed in successfully."
      sign_in_and_redirect(:user, authentication.user)
    elsif user_signed_in?
      # Linked with Github
      current_user.apply_omniauth_with_github(omniauth)
      if current_user.save
        flash[:notice] = "Linked with Github successfully."
      else
        flash[:alert] = "Linked with Github faild."
      end
      redirect_to root_url
    else
      # Sign in with Github
      user = User.where(email: omniauth.info.email).first_or_initialize
      user.username =  omniauth.info.nickname if user.username.blank?
      user.apply_omniauth_with_github(omniauth)
      if user.save
        flash[:notice] = "Signed in successfully."
        sign_in(:user, user)
      else
        session[:omniauth] = omniauth.except('extra')
        flash[:alert] = "Signed in faild."
      end
      redirect_to root_url
    end
  end
end
