# frozen_string_literal: true

class SuperAdmin::NotificationsController < SuperAdminApplicationController
  def index
    limit = RecordLimit.call(params[:limit])

    @q = Notification.ransack(params[:q])
    @notifications = @q.result.order(created_at: :desc)
    @pagy, @notifications = pagy(@notifications, limit:)
  end

  def mark_as_read
    result = Notifications::Read.call(
      notification_id: params[:id]
    )

    if result.success?
      redirect_to super_admin_notifications_path, notice: result.payload[:message]
    else
      redirect_to super_admin_notifications_path, alert: result.error[:notification]
    end
  end

  def mark_all_as_read
    result = Notifications::ReadAll.call

    redirect_to super_admin_notifications_path, notice: result.payload[:message]
  end
end
