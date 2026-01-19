class Invitations::Create < ApplicationService
  def call(invitation:)
    invitation = Invitation.new(invitation)

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
