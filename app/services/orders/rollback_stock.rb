# frozen_string_literal: true

class Orders::RollbackStock < ApplicationService
  def call(order:)
    order.order_items.each { |item| rollback_item(item) }
  end

  private

  def rollback_item(order_item)
    order_item.order_item_filled_details.find_each do |filled|
      restore_available(filled)
      filled.destroy!
    end
  end

  def restore_available(filled)
    available = filled.product_available

    available.with_lock do
      available.update!(
        quantity: available.quantity + filled.quantity
      )
    end
  end
end
