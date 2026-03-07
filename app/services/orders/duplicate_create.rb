# frozen_string_literal: true

class Orders::DuplicateCreate < ApplicationService
  def call(order_batch:, form:)
    orders = []

    ActiveRecord::Base.transaction do
      form.orders.each do |item|
        order = build_order(order_batch, form, item)

        order.save!
        fulfill_stock(order)

        orders << order
      end
    end

    success(
      orders: orders,
      message: "#{orders.size} orders were successfully created."
    )
  rescue ActiveRecord::RecordInvalid => e
    failure(error: e.message)
  end

  private

  def build_order(order_batch, form, item)
    Order.new(
      order_batch_id: order_batch.id,
      courier_service_id: form.courier_service_id,
      order_number: item.order_number,
      tracking_number: item.tracking_number,
      order_items_attributes: [
        {
          product_id: form.product_id,
          variant: form.variant,
          quantity: form.quantity
        }
      ]
    )
  end

  def fulfill_stock(order)
    Orders::StockFulfillment.call(order: order)
  end
end
