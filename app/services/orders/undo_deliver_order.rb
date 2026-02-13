# frozen_string_literal: true

class Orders::UndoDeliverOrder < ApplicationService
  def call(order:)
    return failure(message: 'Order is already preparing.') if order.preparing?

    if order.update(status: :preparing, delivered_by_id: nil, delivered_at: nil)
      success(
        order: order,
        message: 'Order status has been successfully changed.'
      )
    else
      failure(order: order)
    end
  end
end
