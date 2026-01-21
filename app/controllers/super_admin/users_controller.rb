# frozen_string_literal: true

class SuperAdmin::UsersController < SuperAdminApplicationController
  def index
    limit = RecordLimit.call(params[:limit])

    @q = User.ransack(params[:q])
    @users = @q.result(order: :asc).where.not(role: "super_admin")
    @pagy, @users = pagy(@users, limit:)
  end
end
