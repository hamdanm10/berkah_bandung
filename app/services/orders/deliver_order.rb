# frozen_string_literal: true

class Orders::DeliverOrder < ApplicationService
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

    order.update!(
      status: :delivered,
      delivered_by_id: Current.user.id,
      delivered_at: Time.current
    )

    order = Order
            .with_total_items
            .includes(:delivered_by, :courier_service, order_batch: :merchant)
            .find(order.id)

    success(
      order: order,
      message: 'Order was successfully delivered.'
    )
  rescue ActiveRecord::RecordInvalid
    failure(form: form)
  end
end
