class OmniauthRegistrationsController < ApplicationController
  skip_before_action :authenticate_user!
  before_action :deny_spammers!, only: [:create]
  invisible_captcha only: [:create], on_spam: :redirect_spammers!

  def new
    omniauth_data = session['devise.omniauth_data']
    if omniauth_data.nil?
      redirect_to new_user_registration_path and return
    end
    @user = User.new(omniauth_data)
    @minimum_password_length = User.password_length.min
  end

  def create
    omniauth_data = session['devise.omniauth_data']
    if omniauth_data.nil?
      redirect_to new_user_registration_path and return
    end
    user_data = omniauth_data.merge(registration_params)
    user = User.create(user_data)
    if user.persisted?
      session.delete(:'devise.omniauth_data')
      sign_in user
      redirect_to edit_user_registration_path
    else
      flash[:alert] = user.errors.full_messages.join(", ")
      redirect_to new_omniauth_registration_path
    end
  end

  private
  def registration_params
    params.require(:user).permit(
      :password, :password_confirmation, :receive_email, :humanizer_answer, :humanizer_question_id
    )
  end
end
