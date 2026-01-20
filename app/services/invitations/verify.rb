# frozen_string_literal: true

class Invitations::Verify < ApplicationService
  def call(invitation_code:)
    invitation = Invitation.find_by(invitation_code: invitation_code.upcase)

    return failure(message: "Invalid invitation code") unless invitation
    return failure(message: "Invitation is not usable") unless invitation.usable?

    success(invitation: invitation, message: "Invitation code verified successfully.")
  end
end
