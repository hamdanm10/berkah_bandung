# frozen_string_literal: true

class Orders::PaidOrder < ApplicationService
  def call(scan_order_params:)
    form = ScanOrderForm.new(scan_order_params)

    return failure(form: form) unless form.valid?

    order = Order.find_by(
      order_number: form.order_number,
      deleted_at: nil
    )

    unless order&.delivered?
      form.errors.add(:order_number, 'is not in delivered status')
      return failure(form: form)
    end

    order.update!(
      status: :paid,
      paid_by_id: Current.user.id,
      paid_at: Time.current
    )

    order = Order
            .with_total_items
            .includes(:paid_by, :courier_service, order_batch: :merchant)
            .find(order.id)

    success(
      order: order,
      message: 'Order was successfully paid.'
    )
  rescue ActiveRecord::RecordInvalid
    failure(form: form)
  end
end
