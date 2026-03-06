# frozen_string_literal: true

class Orders::UndoReturnOrder < ApplicationService
  def call(order:)
    ActiveRecord::Base.transaction do
      validate_order!(order)

      order.order_items.includes(
        order_item_return: {
          order_item_returned_details: {
            order_item_filled_detail: :product_available
          }
        }
      ).each do |order_item|
        undo_item_return!(order_item)
      end

      order.update!(
        status: 'delivered',
        returned_by_id: nil,
        returned_at: nil
      )

      success(message: 'Order status has been successfully changed.')
    end
  rescue StandardError => e
    Rails.logger.error '===== UNDO RETURN ERROR ====='
    Rails.logger.error e.message
    Rails.logger.error e.backtrace.first(5)

    failure(order: 'Failed to undo return')
  end

  private

  def validate_order!(order)
    raise 'Order not found' unless order
    raise 'Order is not returned' unless order.status == 'returned'
  end

  def undo_item_return!(order_item)
    order_item_return = order_item.order_item_return
    return unless order_item_return

    order_item_return.order_item_returned_details.each do |detail|
      good_stock = detail.good_stock.to_i
      next if good_stock <= 0

      available = detail.order_item_filled_detail.product_available

      available.with_lock do
        available.update!(
          quantity: available.quantity - good_stock
        )
      end
    end

    order_item_return.order_item_returned_details.destroy_all
    order_item_return.destroy!
  end
end
