# frozen_string_literal: true

class Orders::StockFulfillment < ApplicationService
  def call(order:)
    ActiveRecord::Base.transaction do
      order.order_items.each do |item|
        fulfill_item(item)
      end
    end
  end

  private

  def fulfill_item(item)
    remaining = item.quantity

    availables = ProductAvailable
                 .where(product_id: item.product_id)
                 .order(cost_price: :asc)
                 .lock
                 .to_a

    if availables.empty?
      item.errors.add(:product_id, 'has no stock data')
      raise ActiveRecord::RecordInvalid.new(item)
    end

    availables.each do |available|
      break if remaining.zero?

      next if available.quantity <= 0

      used = [available.quantity, remaining].min

      create_tracking(item, available, used)

      available.update_columns(
        quantity: available.quantity - used
      )

      remaining -= used
    end

    return unless remaining.positive?

    most_expensive = availables.last

    create_tracking(item, most_expensive, remaining)

    most_expensive.update_columns(
      quantity: most_expensive.quantity - remaining
    )
  end

  def create_tracking(item, available, quantity)
    OrderItemFilledDetail.create!(
      order_item: item,
      product_available: available,
      quantity: quantity
    )
  end
end
