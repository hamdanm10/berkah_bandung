# frozen_string_literal: true

class Orders::StockFulfillment < ApplicationService
  def call(order:)
    order.order_items.each { |item| fulfill(item) }
  end

  private

  def fulfill(order_item)
    remaining = order_item.quantity

    product_availables(order_item).each do |available|
      break if remaining.zero?
      next if available.quantity.zero?

      used = [available.quantity, remaining].min

      create_filled_detail(order_item, available, used)
      available.update!(quantity: available.quantity - used)

      remaining -= used
    end

    reserve_remaining(order_item, remaining) if remaining.positive?
  end

  def product_availables(order_item)
    order_item.product
              .product_availables
              .order(cost_price: :asc)
              .lock
  end

  def create_filled_detail(order_item, available, quantity)
    OrderItemFilledDetail.create!(
      order_item: order_item,
      product_available: available,
      quantity: quantity
    )
  end

  def reserve_remaining(order_item, quantity)
    OrderItemReservedDetail.create!(
      order_item: order_item,
      quantity: quantity,
      status: :pending
    )

    increase_product_reserve(order_item.product, quantity)
  end

  def increase_product_reserve(product, quantity)
    reserve = product.product_reserve
    reserve.update!(quantity: reserve.quantity + quantity)
  end
end
