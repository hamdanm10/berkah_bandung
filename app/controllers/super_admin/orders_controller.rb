# frozen_string_literal: true

class SuperAdmin::OrdersController < SuperAdminApplicationController
  def index
    @merchant = merchant_scope
    @order_batch = order_batch_scope

    limit = RecordLimit.call(params[:limit])

    @q = @order_batch.orders.where(deleted_at: nil).ransack(params[:q])
    @orders = @q
      .result
      .with_total_items
      .includes(:courier_service)
      .order(created_at: :desc)
    @pagy, @orders = pagy(@orders, limit:)
  end

  def new
    @merchant = merchant_scope
    @order_batch = order_batch_scope

    @order = Order.new
    @order.order_items.build

    assign_dropdown_search_labels(@order)
  end

  def create
    @merchant = merchant_scope
    @order_batch = order_batch_scope

    result = Orders::Create.call(
      order_batch: @order_batch,
      order_params: order_params
    )

    if result.success?
      redirect_to new_super_admin_merchant_order_order_batch_order_path(@merchant, @order_batch), notice: result.payload[:message]
    else
      @order = result.error[:order]
      assign_dropdown_search_labels(@order)

      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @merchant = merchant_scope
    @order_batch = order_batch_scope

    @order = order_scope
    assign_dropdown_search_labels(@order)
  end

  def update
    @merchant = merchant_scope
    @order_batch = order_batch_scope
    @order = order_scope

    result = Orders::Update.call(
      order: @order,
      order_params: order_params
    )

    if result.success?
      order = result.payload[:order]

      redirect_to edit_super_admin_merchant_order_order_batch_order_path(@merchant, @order_batch, order), notice: result.payload[:message]
    else
      @order = result.error[:order]
      assign_dropdown_search_labels(@order)

      render :edit, status: :unprocessable_entity
    end
  end

  private

  def order_params
    params.require(:order).permit(
      :order_number,
      :tracking_number,
      :courier_service_id,
      order_items_attributes: [
        :id,
        :product_id,
        :quantity,
        :_destroy
      ]
    )
  end

  def merchant_scope
    Merchant.where(is_active: true, deleted_at: nil).find(params[:merchant_order_id])
  end

  def order_batch_scope
    merchant_scope.order_batches.where(deleted_at: nil).find(params[:order_batch_id])
  end

  def order_scope
    order_batch_scope.orders.where(deleted_at: nil).find(params[:id])
  end

  def assign_dropdown_search_labels(order)
    @courier_service_label = order.courier_service&.name
  end
end
