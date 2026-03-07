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
    result = Invitations::Create.call(
      invitation_params: invitation_params
    )

    if result.success?
      redirect_to new_super_admin_invitation_path, notice: result.payload[:message]
    else
      @invitation = result.error[:invitation]

      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @invitation = invitation_scope
  end

  def update
    result = Invitations::Update.call(
      invitation: invitation_scope,
      invitation_params: invitation_params
    )

    if result.success?
      invitation = result.payload[:invitation]

      redirect_to edit_super_admin_invitation_path(invitation), notice: result.payload[:message]
    else
      @invitation = result.error[:invitation]

      render :edit, status: :unprocessable_entity
    end
  end

  private

  def invitation_params
    params.require(:invitation).permit(:assigned_role)
  end

  def invitation_scope
    invitation = Invitation.find(params[:id])
    return invitation if invitation.usable?

    raise ActiveRecord::RecordNotFound
  end
end
