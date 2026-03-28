# frozen_string_literal: true

class Notifications::Read < ApplicationService
  def call(notification_id:)
    notification = Notification.find_by(
      id: notification_id,
      read_at: nil
    )

    return failure(notification: notification) if notification.read_at.present?

    notification.update!(
      read_at: Time.current
    )

    success(
      notification: notification,
      message: 'Notification was successfully read.'
    )
  end
end
