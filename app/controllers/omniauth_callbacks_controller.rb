class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  skip_before_action :verify_authenticity_token
  before_action :deny_spammers!

  def google
    @user = User.from_omniauth(request.env['omniauth.auth'], honeypot)

    if @user
      flash[:notice] = I18n.t :'devise.omniauth_callbacks.success', :kind => 'Google'
      sign_in_and_redirect @user, :event => :authentication
    else
      session['devise.omniauth_data'] = User.omniauth_user_data(request.env['omniauth.auth'], honeypot)
      redirect_to new_omniauth_registration_path
    end
  end
end
