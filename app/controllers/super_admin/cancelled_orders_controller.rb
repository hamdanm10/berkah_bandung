# frozen_string_literal: true

class SuperAdmin::CancelledOrdersController < SuperAdminApplicationController
  def index
    limit = RecordLimit.call(params[:limit])

    @q = Order.where(deleted_at: nil, status: :cancelled).ransack(params[:q])
    @orders = @q
              .result
              .with_total_items
              .includes(:cancelled_by, :courier_service, order_batch: :merchant)
              .order(created_at: :desc)
    @pagy, @orders = pagy(@orders, limit:)
  end
end
