# frozen_string_literal: true

class OrderBatches::SoftDelete < ApplicationService
  def call(order_batch:)
    return failure(message: "Order batch is already deleted.") if order_batch.deleted_at.present?
    return failure(message: "This order batch cannot be deleted because it contains existing orders.") if order_batch.orders.present?

    if order_batch.update(
      deleted_at: Time.current,
    )
      success(
        order_batch: order_batch,
        message: "Order batch has been successfully deleted."
      )
    else
      failure(order_batch: order_batch)
    end
  end
end
