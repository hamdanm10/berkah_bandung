# frozen_string_literal: true

class Orders::UndoCancelOrder < ApplicationService
  def call(order:)
    return failure(message: 'Order cannot be undo unless it is cancelled') unless order.cancelled?

    ActiveRecord::Base.transaction do
      undo_cancel_order(order)
      fulfill_stock(order)
    end

    success(
      order: order,
      message: 'Order status has been successfully changed.'
    )
  end

  private

  def fulfill_stock(order)
    Orders::StockFulfillment.call(order: order)
  end

  def undo_cancel_order(order)
    order.update!(
      status: :preparing,
      cancelled_by_id: nil,
      cancelled_at: nil
    )
  end
end
