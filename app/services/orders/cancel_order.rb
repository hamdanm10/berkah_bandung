# frozen_string_literal: true

class Orders::CancelOrder < ApplicationService
  def call(scan_order_params:)
    form = ScanOrderForm.new(scan_order_params)

    return failure(form: form) unless form.valid?

    order = Order.find_by(
      order_number: form.order_number,
      deleted_at: nil
    )

    unless order&.preparing?
      form.errors.add(:order_number, 'is not in preparing status')
      return failure(form: form)
    end

    ActiveRecord::Base.transaction do
      rollback_stock(order)
      cancel_order(order)
    end

    order = Order
            .with_total_items
            .includes(:cancelled_by, :courier_service, order_batch: :merchant)
            .find(order.id)

    success(
      order: order,
      message: 'Order was successfully cancelled.'
    )
  rescue ActiveRecord::RecordInvalid
    failure(form: form)
  end

  private

  def rollback_stock(order)
    Orders::RollbackStock.call(order: order)
  end

  def cancel_order(order)
    order.update!(
      status: :cancelled,
      cancelled_by_id: Current.user.id,
      cancelled_at: Time.current
    )
  end
end
