# frozen_string_literal: true

class RegistrationsController < ApplicationController
  allow_unauthenticated_access

  layout "guest/application"

  def new
    result = Registrations::Verify.call(invitation_code: session[:invitation_code])

    if result.success?
      @user = User.new
    else
      session.delete(:invitation_code)
      redirect_to new_invitation_path, alert: result.error[:message]
    end
  end

  def create
    verify = Registrations::Verify.call(
      invitation_code: session[:invitation_code]
    )

    unless verify.success?
      session.delete(:invitation_code)
      redirect_to new_invitation_path, alert: verify.error[:message]
      return
    end

    result = Registrations::Create.call(
      user_params: user_params,
      invitation: verify.payload[:invitation]
    )

    if result.success?
      session.delete(:invitation_code)
      start_new_session_for result.payload[:user]
      redirect_to after_authentication_url, notice: result.payload[:message]
    else
      @user = result.error[:user]
      render :new, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:full_name, :username, :password, :password_confirmation)
  end
end
