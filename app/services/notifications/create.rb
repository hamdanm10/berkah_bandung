# frozen_string_literal: true

class Notifications::Create < ApplicationService
  def call(title:, message:, notifiable:, type:)
    Notification.create!(
      title: title,
      message: message,
      notifiable: notifiable,
      notification_type: type
    )
  end
end
