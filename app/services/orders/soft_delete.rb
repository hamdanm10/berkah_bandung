# frozen_string_literal: true

class Orders::SoftDelete < ApplicationService
  def call(order:)
    ActiveRecord::Base.transaction do
      rollback_stock(order)
      soft_delete_order(order)
    end

    success(order: order, message: 'Order was successfully deleted.')
  rescue ActiveRecord::RecordInvalid
    failure(order: order)
  end

  private

  def rollback_stock(order)
    Orders::RollbackStock.call(order: order)
  end

  def soft_delete_order(order)
    order.update!(deleted_at: Time.current)
  end
end
