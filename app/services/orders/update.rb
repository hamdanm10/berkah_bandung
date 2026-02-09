# frozen_string_literal: true

class Orders::Update < ApplicationService
  def call(order:, order_params:)
    return failure(message: 'Order cannot be updated unless it is preparing') unless order.preparing?

    ActiveRecord::Base.transaction do
      rollback_stock(order)
      order.update!(order_params)
      fulfill_stock(order)
    end

    success(order: order, message: 'Order was successfully updated.')
  rescue ActiveRecord::RecordInvalid
    failure(order: order)
  end

  private

  def rollback_stock(order)
    Orders::RollbackStock.call(order: order)
  end

  def fulfill_stock(order)
    Orders::StockFulfillment.call(order: order)
  end
end
