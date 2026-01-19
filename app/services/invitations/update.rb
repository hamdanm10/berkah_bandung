# frozen_string_literal: true

class Invitations::Update < ApplicationService
  def call(invitation:, invitation_params:)
    invitation.assign_attributes(invitation_params)

    if invitation.save
      success(
        invitation: invitation,
        message: "Invitation was successfully updated."
      )
    else
      failure(invitation: invitation)
    end
  end
end
