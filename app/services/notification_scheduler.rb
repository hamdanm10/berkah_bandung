# frozen_string_literal: true

class NotificationScheduler < ApplicationService
  INTERVAL = 1.minutes

  def call
    setting = AppSetting.first

    return unless setting.last_stock_check.nil? ||
                  setting.last_stock_check < INTERVAL.ago

    ApplicationRecord.transaction do
      Schedulers::StockChecker.call
      setting.update!(last_stock_check: Time.current)
    end
  end
end
