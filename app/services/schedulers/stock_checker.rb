# frozen_string_literal: true

class Schedulers::StockChecker < ApplicationService
  LOW_STOCK_LIMIT = 10

  def call
    Product
      .with_total_quantity
      .where('COALESCE(availables.sum_qty, 0) <= ?', LOW_STOCK_LIMIT)
      .find_each do |product|
        next if Notification.exists?(
          notifiable: product,
          notification_type: 'low_stock',
          read_at: nil
        )

        Notifications::Create.call(
          title: 'Low Stock',
          message: "#{product.name} stock is running low (#{product.total_quantity} remaining)",
          notifiable: product,
          type: 'low_stock'
        )
    end
  end
end
