# frozen_string_literal: true

class SuperAdmin::InvitationsController < SuperAdminApplicationController
  def index
    limit = RecordLimit.call(params[:limit])

    @q = Invitation.ransack(params[:q])
    @invitations = @q.result.order(created_at: :desc)
    @pagy, @invitations = pagy(@invitations, limit:)
  end

  def new
    @invitation = Invitation.new
  end

  def create
    result = Invitations::Create.call(invitation: invitation_params)

    if result.success?
      redirect_to new_super_admin_invitation_path, notice: result.payload[:message]
    else
      @invitation = result.error[:invitation]

      render :new, status: :unprocessable_entity
    end
  end

  private

  def invitation_params
    params.require(:invitation).permit(:assigned_role)
  end
end
