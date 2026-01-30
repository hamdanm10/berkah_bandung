# frozen_string_literal: true

class Registrations::Verify < ApplicationService
  def call(invitation_code:)
    invitation = Invitation.find_by(invitation_code: invitation_code)

    return failure(message: "Please enter your invitation code.") if invitation.nil?
    return failure(message: "Invitation is not usable") unless invitation.usable?

    success(invitation: invitation)
  end
end
