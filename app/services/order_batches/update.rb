# frozen_string_literal: true

class OrderBatches::Update < ApplicationService
  def call(order_batch:, order_batch_params:)
    order_batch.assign_attributes(order_batch_params)

    if order_batch.save
      success(
        order_batch: order_batch,
        message: "Order batch was successfully updated."
      )
    else
      failure(order_batch: order_batch)
    end
  end
end
