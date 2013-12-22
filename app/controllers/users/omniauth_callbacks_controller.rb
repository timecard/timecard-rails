class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  include Devise::Controllers::Rememberable

  def github
    callback
  end

  def ruffnote
    callback
  end

  def callback
    omniauth = request.env["omniauth.auth"]
    authentication = Authentication.where(provider: omniauth.provider, uid: omniauth.uid).first
    if authentication.present?
      flash[:notice] = "Signed in successfully."
      remember_me(authentication.user)
      sign_in_and_redirect(:user, authentication.user)
    else
      prov = omniauth.provider
      if user_signed_in? #sync
        current_user.send("apply_omniauth_with_#{prov}", omniauth)
        if current_user.save
          flash[:notice] = "Linked with #{prov} successfully."
        else
          flash[:alert] = "Linked with #{prov} faild."
        end
      else #signin
        user = User.where(email: omniauth.info.email).first_or_initialize
        user.name =  omniauth.info.nickname if user.name.blank?
        user.send("apply_omniauth_with_#{prov}", omniauth)
        if user.save
          flash[:notice] = "Signed in successfully."
          remember_me(authentication.user)
          sign_in(:user, user)
        else
          session[:omniauth] = omniauth.except('extra')
          flash[:alert] = "Signed in faild."
        end
      end
      redirect_to root_url
    end
  end
end
