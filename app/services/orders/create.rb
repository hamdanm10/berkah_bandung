# frozen_string_literal: true

class Orders::Create < ApplicationService
  def call(order_batch:, order_params:)
    order = Order.new(
      order_params.merge(
        order_batch_id: order_batch.id
      )
    )

    ActiveRecord::Base.transaction do
      if order.save
        process_stock!(order)

        success(
          order: order,
          message: "Order was successfully created."
        )
      else
        failure(order: order)
      end
    end
  end

  private

  def process_stock!(order)
    order.order_items.each do |item|
      product = Product.lock.find(item.product_id)
      qty     = item.quantity

      total_available = product.product_prices.sum(:quantity)

      if total_available >= qty
        reduce_from_prices!(product, qty)
      else
        reduce_from_prices!(product, total_available)

        shortage = qty - total_available
        product.increment!(:reserved_quantity, shortage)
      end
    end
  end

  def reduce_from_prices!(product, qty)
    remaining = qty

    product.product_prices.order(:cost_price).each do |price|
      break if remaining.zero?

      if price.quantity >= remaining
        price.update!(quantity: price.quantity - remaining)
        remaining = 0
      else
        remaining -= price.quantity
        price.update!(quantity: 0)
      end
    end
  end
end
