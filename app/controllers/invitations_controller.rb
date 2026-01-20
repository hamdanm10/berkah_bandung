# frozen_string_literal: true

class InvitationsController < ApplicationController
  allow_unauthenticated_access

  layout "guest/application"

  def new
  end

  def verify
    result = Invitations::Verify.call(invitation_code: params[:invitation_code])

    if result.success?
      session[:invitation_code] = result.payload[:invitation].invitation_code
      redirect_to new_registration_path, notice: result.payload[:message]
    else
      redirect_to new_invitation_path, alert: result.error[:message]
    end
  end
end
