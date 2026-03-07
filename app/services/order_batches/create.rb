# frozen_string_literal: true

class OrderBatches::Create < ApplicationService
  def call(merchant:, order_batch_params:)
    order_batch = OrderBatch.new(order_batch_params)
    order_batch.merchant_id = merchant.id
    order_batch.created_by_user_id = Current.user.id

    if order_batch.save
      success(
        order_batch: order_batch,
        message: "Batch was successfully created."
      )
    else
      failure(order_batch: order_batch)
    end
  end
end
