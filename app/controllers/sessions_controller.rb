class SessionsController < ApplicationController
  allow_unauthenticated_access only: %i[ new create ]
  rate_limit to: 10, within: 3.minutes, only: :create, with: -> { redirect_to login_url, alert: t("sessions.messages.rate_limit") }

  def new
  end

  def create
    if (user = User.authenticate_by(params.permit(:name, :email, :password)))
      start_new_session_for user
      redirect_to after_authentication_url
    else
      redirect_to login_path, alert: t("sessions.messages.not_authenticate")
    end
  end

  def destroy
    terminate_session
    redirect_to login_path
  end
end
