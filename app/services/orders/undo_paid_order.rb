# frozen_string_literal: true

class Orders::UndoPaidOrder < ApplicationService
  def call(order:)
    return failure(message: 'Order is already delivered.') if order.delivered?

    if order.update(status: :delivered, paid_by_id: nil, paid_at: nil)
      success(
        order: order,
        message: 'Order status has been successfully changed.'
      )
    else
      failure(order: order)
    end
  end
end
