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
end
