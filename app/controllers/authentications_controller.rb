class AuthenticationsController < ApplicationController
  def index
    @authentications = current_user.authentications if current_user
  end

  def create
    omniauth = request.env["omniauth.auth"]
    authentication = Authentication.find_by_provider_and_uid(omniauth['provider'], omniauth['uid'])

    if authentication
      #Existing user, existing authentication
      flash[:notice] = "Signed in successfully."
      sign_in_and_redirect(:user, authentication.user)
    elsif current_user
      #Existing user, new authentication
      current_user.apply_omniauth!(omniauth)
      flash[:notice] = "Authentication successful."
      redirect_to authentications_url
    else
      #Entirely new user
      user = User.new
      user.apply_omniauth(omniauth)
      if user.save
      case omniauth['provider']
        when 'facebook'
          user.add_facebook_info
        when 'linked_in'
          user.add_linked_in_info
        when 'twitter'
          user.add_twitter_info
      end
        flash[:notice] = "Signed in successfully."
        sign_in_and_redirect(:user, user)
      else
        session[:omniauth] = omniauth.except('extra')
        redirect_to new_user_registration_url
      end
    end
  end

  def auth_failure
   # just render the failure view
   end

  def destroy
    @authentication = current_user.authentications.find(params[:id])
    @authentication.destroy
    flash[:notice] = "Successfully destroyed authentication."
    redirect_to authentications_url
  end
end
