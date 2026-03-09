# frozen_string_literal: true

class ReturnAdmin::ReturnedOrdersController < ReturnAdminApplicationController
  def index
    limit = RecordLimit.call(params[:limit])

    @q = Order.where(deleted_at: nil, status: :returned).ransack(params[:q])
    @orders = @q
              .result
              .with_total_items
              .includes(:returned_by, :courier_service, order_batch: :merchant)
              .order(returned_at: :desc)
    @pagy, @orders = pagy(@orders, limit:)
  end

  def show
    @order = order_scope
  end

  def new
    @scan_order = ScanOrderForm.new
  end

  def create
    @return_form = ReturnOrderForm.new(return_order_params)

    return render_return_form unless @return_form.valid?

    result = Orders::ReturnOrder.call(
      order: @return_form.order,
      return_params: return_order_params
    )

    return render_return_form unless result.success?

    order = Order
            .with_total_items
            .includes(
              :courier_service,
              order_batch: %i[user_created merchant],
              order_items: %i[product order_item_return]
            )
            .find_by!(
              id: @return_form.order.id,
              deleted_at: nil,
              status: :returned
            )

    render turbo_stream: [
      turbo_stream.update('return_section', ''),
      turbo_stream.replace(
        'scan_section',
        partial: 'return_admin/returned_orders/scan_order_form',
        locals: {
          url: scan_order_return_admin_returned_orders_path,
          scan_order: ScanOrderForm.new
        }
      ),
      turbo_stream.replace(
        'return_results',
        partial: 'return_admin/returned_orders/return_results',
        locals: { order: order }
      )
    ]
  end

  def scan_order
    @scan_order = ScanOrderForm.new(scan_order_params)

    return render_scan_form unless @scan_order.valid?

    order = Order.includes(order_items: :product)
                 .find_by(order_number: @scan_order.order_number)

    unless order&.delivered?
      @scan_order.errors.add(:order_number, 'Order is not in delivered status')
      return render_scan_form
    end

    render turbo_stream: [
      turbo_stream.update(
        'return_section',
        partial: 'return_admin/returned_orders/return_form',
        locals: {
          order: order,
          return_form: ReturnOrderForm.new(
            order_id: order.id,
            items: {}
          )
        }
      ),
      turbo_stream.update('return_results', '')
    ]
  end

  def undo
    result = Orders::UndoReturnOrder.call(
      order: order_scope
    )

    if result.success?
      redirect_to return_admin_returned_orders_path, notice: result.payload[:message]
    else
      redirect_to return_admin_returned_orders_path, alert: result.error[:order]
    end
  end

  private

  def render_return_form
    render turbo_stream: turbo_stream.update(
      'return_section',
      partial: 'return_admin/returned_orders/return_form',
      locals: {
        order: @return_form.order,
        return_form: @return_form
      }
    )
  end

  def render_scan_form
    render turbo_stream: turbo_stream.replace(
      'scan_section',
      partial: 'return_admin/returned_orders/scan_order_form',
      locals: {
        url: scan_order_return_admin_returned_orders_path,
        scan_order: @scan_order
      }
    )
  end

  def return_order_params
    params.require(:return_order_form)
          .permit(:order_id, items: [:good_stock])
  end

  def order_scope
    Order
      .with_total_items
      .includes(:courier_service, order_batch: %i[user_created merchant], order_items: %i[product order_item_return])
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
