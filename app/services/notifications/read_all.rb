# frozen_string_literal: true

class Notifications::ReadAll < ApplicationService
  def call
    notifications = Notification.where(read_at: nil)

    notifications.update(
      read_at: Time.current
    )

    success(
      message: 'All notification was successfully read.'
    )
  end
end
