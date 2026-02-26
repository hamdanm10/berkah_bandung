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

  def new
    @scan_order = ScanOrderForm.new
  end

  def create
  end

  def scan_order
    @scan_order = ScanOrderForm.new(scan_order_params)

    if @scan_order.valid?
      order = Order.includes(order_items: :product).find_by(order_number: @scan_order.order_number)

      unless order&.delivered?
        @scan_order.errors.add(:order_number, 'Order is not in delivered status')

        return render turbo_stream: turbo_stream.replace(
          'scan_section',
          partial: 'super_admin/returned_orders/scan_order_form',
          locals: {
            url: scan_order_super_admin_returned_orders_path,
            scan_order: @scan_order
          }
        )
      end

      render turbo_stream: turbo_stream.update(
        'return_section',
        partial: 'super_admin/returned_orders/return_form',
        locals: { order: order }
      )
    else
      render turbo_stream: turbo_stream.replace(
        'scan_section',
        partial: 'super_admin/returned_orders/scan_order_form',
        locals: {
          url: scan_order_super_admin_returned_orders_path,
          scan_order: @scan_order
        }
      )
    end
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

  def scan_order_params
    params.require(:scan_order_form).permit(:order_number)
  end
end
