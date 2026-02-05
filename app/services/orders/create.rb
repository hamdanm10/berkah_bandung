# frozen_string_literal: true

class Orders::Create < ApplicationService
  def call(order_batch:, order_params:)
    order = build_order(order_batch, order_params)

    ActiveRecord::Base.transaction do
      order.save!
      fulfill_stock(order)
    end

    success(order: order, message: 'Order was successfully created.')
  rescue ActiveRecord::RecordInvalid
    failure(order: order)
  end

  private

  def build_order(order_batch, params)
    Order.new(params.merge(order_batch_id: order_batch.id))
  end

  def fulfill_stock(order)
    Orders::StockFulfillment.call(order: order)
  end
end
