# frozen_string_literal: true

class SuperAdminApplicationController < ApplicationController
  before_action :authenticate_super_admin!
  before_action :run_notification_scheduler
  before_action :load_notifications

  layout 'super_admin/application'

  private

  def authenticate_super_admin!
    return if Current.user&.super_admin?

    head :forbidden
  end

  def run_notification_scheduler
    NotificationScheduler.call
  end

  def load_notifications
    @recent_notifications = Notification
                            .where(read_at: nil)
                            .order(created_at: :desc)
                            .limit(5)
  end
end
