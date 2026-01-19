# frozen_string_literal: true

class Invitations::Create < ApplicationService
  def call(invitation_params:)
    invitation = Invitation.new(invitation_params)

    if invitation.save
      success(
        invitation: invitation,
        message: "Invitation was successfully created."
      )
    else
      failure(invitation: invitation)
    end
  end
end
