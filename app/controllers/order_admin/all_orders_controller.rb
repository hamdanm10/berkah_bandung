# frozen_string_literal: true

class OrderAdmin::AllOrdersController < OrderAdminApplicationController
  def index
    limit = RecordLimit.call(params[:limit])

    @q = Order
         .joins(:order_batch)
         .where(
           deleted_at: nil,
           order_batches: { created_by_user_id: current_user.id }
         )
         .ransack(params[:q])

    @orders = @q
              .result
              .with_total_items
              .includes(:courier_service, order_batch: %i[user_created merchant])
              .order(created_at: :desc)

    @pagy, @orders = pagy(@orders, limit:)
  end

  def show
    @order = order_scope
  end

  private

  def order_scope
    Order
      .joins(:order_batch)
      .with_total_items
      .includes(:courier_service, order_batch: %i[user_created merchant], order_items: :product)
      .find_by!(
        id: params[:id],
        deleted_at: nil,
        order_batches: { created_by_user_id: current_user.id }
      )
  end
end
