# frozen_string_literal: true

class Orders::Update < ApplicationService
  def call(order:, order_params:)
    ActiveRecord::Base.transaction do
      previous_items = snapshot_items(order)

      rollback_stock!(previous_items)

      if order.update(order_params)
        process_stock!(order)

        success(
          order: order,
          message: "Order was successfully updated."
        )
      else
        failure(order: order)
      end
    end
  end

  private

  # ========================
  # SNAPSHOT SEBELUM UPDATE
  # ========================
  def snapshot_items(order)
    order.order_items.map do |item|
      {
        product_id: item.product_id,
        quantity: item.quantity
      }
    end
  end

  # ========================
  # ROLLBACK OLD STOCK
  # ========================
  def rollback_stock!(items)
    items.each do |item|
      product = Product.lock.find(item[:product_id])
      qty     = item[:quantity]

      restore_to_prices!(product, qty)
    end
  end

  def restore_to_prices!(product, qty)
    remaining = qty

    if product.reserved_quantity.positive?
      reduce = [ product.reserved_quantity, remaining ].min
      product.decrement!(:reserved_quantity, reduce)
      remaining -= reduce
    end

    return if remaining.zero?

    product.product_prices.order(cost_price: :desc).each do |price|
      break if remaining.zero?

      price.update!(quantity: price.quantity + remaining)
      remaining = 0
    end
  end

  # ========================
  # APPLY NEW STOCK
  # ========================
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
