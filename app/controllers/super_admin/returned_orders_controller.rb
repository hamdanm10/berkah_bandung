# frozen_string_literal: true

class SuperAdmin::ReturnedOrdersController < SuperAdminApplicationController
  def index
    limit = RecordLimit.call(params[:limit])

    @q = Order.where(deleted_at: nil, status: :returned).ransack(params[:q])
    @orders = @q
              .result
              .with_total_items
              .includes(:returned_by, :courier_service, order_batch: :merchant)
              .order(created_at: :desc)
    @pagy, @orders = pagy(@orders, limit:)
  end

  def show
    @order = order_scope
  end

  private

  def order_scope
    Order
      .with_total_items
      .includes(:courier_service, order_batch: %i[user_created merchant], order_items: :product)
      .find_by!(
        id: params[:id],
        deleted_at: nil,
        status: :returned
      )
  end
end
