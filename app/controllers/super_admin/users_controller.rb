# frozen_string_literal: true

class SuperAdmin::UsersController < SuperAdminApplicationController
  def index
    limit = RecordLimit.call(params[:limit])

    @q = User.ransack(params[:q])
    @users = @q
      .result
      .where.not(role: "super_admin")
      .order(full_name: :asc)

    @pagy, @users = pagy(@users, limit:)
  end

  def activate
    result = Users::Activate.call(
      user: user_scope
    )

    if result.success?
      redirect_to super_admin_users_path, notice: result.payload[:message]
    else
      redirect_to super_admin_users_path, alert: result.error[:user]
    end
  end

  def deactivate
    result = Users::Deactivate.call(
      user: user_scope
    )

    if result.success?
      redirect_to super_admin_users_path, notice: result.payload[:message]
    else
      redirect_to super_admin_users_path, alert: result.error[:user]
    end
  end

  def reset_password
    result = Users::ResetPassword.call(
      user: user_scope
    )

    if result.success?
      redirect_to super_admin_users_path, notice: result.payload[:message]
    else
      redirect_to super_admin_users_path, alert: result.error[:user]
    end
  end

  private

  def user_scope
    User.find(params[:id])
  end
end
