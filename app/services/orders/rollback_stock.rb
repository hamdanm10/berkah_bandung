# frozen_string_literal: true

class Orders::RollbackStock < ApplicationService
  def call(order:)
    order.order_items.each { |item| rollback_item(item) }
  end

  private

  def rollback_item(order_item)
    rollback_filled(order_item)
    rollback_reserved(order_item)
  end

  def rollback_filled(order_item)
    order_item.order_item_filled_details.each do |filled|
      restore_available(filled)
      filled.destroy!
    end
  end

  def restore_available(filled)
    available = filled.product_available
    available.update!(quantity: available.quantity + filled.quantity)
  end

  def rollback_reserved(order_item)
    reserved = order_item.order_item_reserved_detail
    return unless reserved

    decrease_product_reserve(order_item.product, reserved.quantity) if reserved.pending?

    reserved.destroy!
  end

  def decrease_product_reserve(product, quantity)
    reserve = product.product_reserve
    reserve.update!(quantity: reserve.quantity - quantity)
  end
end
