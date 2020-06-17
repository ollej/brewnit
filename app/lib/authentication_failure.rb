class AuthenticationFailure < Devise::FailureApp
  def redirect_url
    new_user_session_url
  end

  def respond
    if http_auth?
      http_auth
    else
      redirect
    end
  end

  def redirect
    store_location!
    message = warden.message || warden_options[:message]
    if message == :timeout
      redirect_to attempted_path
    else
      super
    end
  end
end
