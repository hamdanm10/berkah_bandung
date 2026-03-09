# frozen_string_literal: true

class SuperAdmin::PaidOrdersController < SuperAdminApplicationController
  def index
    limit = RecordLimit.call(params[:limit])

    @q = Order.where(deleted_at: nil, status: :paid).ransack(params[:q])
    @orders = @q
              .result
              .with_total_items
              .includes(:paid_by, :courier_service, order_batch: :merchant)
              .order(paid_at: :desc)
    @pagy, @orders = pagy(@orders, limit:)
  end

  def show
    @order = order_scope
  end

  def new
    @scan_order = ScanOrderForm.new
  end

  def create
    result = Orders::PaidOrder.call(
      scan_order_params: scan_order_params
    )

    if result.success?
      @order = result.payload[:order]
      @scan_order = ScanOrderForm.new
    else
      @scan_order = result.error[:form]
    end

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to new_super_admin_paid_order_path }
    end
  end

  def undo
    result = Orders::UndoPaidOrder.call(
      order: order_scope
    )

    if result.success?
      redirect_to super_admin_paid_orders_path, notice: result.payload[:message]
    else
      redirect_to super_admin_paid_orders_path, alert: result.error[:order]
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
        status: :paid
      )
  end

  def scan_order_params
    params.require(:scan_order_form).permit(:order_number)
  end
end
