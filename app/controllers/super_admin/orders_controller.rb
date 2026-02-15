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

  def show
    @merchant = merchant_scope
    @order_batch = order_batch_scope
    @order = order_scope
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
      redirect_to new_super_admin_merchant_order_order_batch_order_path(@merchant, @order_batch),
                  notice: result.payload[:message]
    else
      @order = result.error[:order]
      assign_dropdown_search_labels(@order)

      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @merchant = merchant_scope
    @order_batch = order_batch_scope

    @order = order_preparing_scope
    assign_dropdown_search_labels(@order)
  end

  def update
    @merchant = merchant_scope
    @order_batch = order_batch_scope
    @order = order_preparing_scope

    result = Orders::Update.call(
      order: @order,
      order_params: order_params
    )

    if result.success?
      order = result.payload[:order]

      redirect_to edit_super_admin_merchant_order_order_batch_order_path(@merchant, @order_batch, order),
                  notice: result.payload[:message]
    else
      @order = result.error[:order]
      assign_dropdown_search_labels(@order)

      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @merchant = merchant_scope
    @order_batch = order_batch_scope

    result = Orders::SoftDelete.call(
      order: order_preparing_scope
    )

    if result.success?
      redirect_to super_admin_merchant_order_order_batch_orders_path(@merchant, @order_batch),
                  notice: result.payload[:message]
    else
      redirect_to super_admin_merchant_order_order_batch_orders_path(@merchant, @order_batch),
                  alert: result.error[:category]
    end
  end

  def duplicate_new
    @merchant = merchant_scope
    @order_batch = order_batch_scope
    @form = DuplicateOrdersForm.new

    @form.product_label = ''
    @form.courier_label = ''
  end

  def duplicate_create
    @merchant = merchant_scope
    @order_batch = order_batch_scope

    @form = DuplicateOrdersForm.new(duplicate_form_params)
    @form.orders = extract_orders_params.map { |o| DuplicateOrderItem.new(o) }

    @form.product_label = Product.find_by(id: @form.product_id)&.then { |p| "#{p.code} | #{p.name}" } || ''
    @form.courier_label = CourierService.find_by(id: @form.courier_service_id)&.name || ''

    if params[:generate]
      unless @form.valid?(:generate)
        render :duplicate_new, status: :unprocessable_entity
        return
      end

      @form.build_orders
      render :duplicate_new, status: :unprocessable_entity
      return
    end

    unless @form.valid?(:create)
      render :duplicate_new, status: :unprocessable_entity
      return
    end

    result = Orders::DuplicateCreate.call(
      order_batch: @order_batch,
      form: @form
    )

    if result.success?
      redirect_to duplicate_new_super_admin_merchant_order_order_batch_orders_path(@merchant, @order_batch),
                  notice: result.payload[:message]
    else
      flash.now[:alert] = result.error[:error]
      render :duplicate_new, status: :unprocessable_entity
    end
  end

  def print
    @order_batch = order_batch_scope

    base_scope = OrderItem
                 .joins(:order)
                 .where(orders: { order_batch_id: params[:order_batch_id] })

    @order_items = base_scope
                   .group('order_items.product_name')
                   .select(
                     'order_items.product_name AS product_name,
                    SUM(order_items.quantity) AS total_quantity'
                   )
                   .order('order_items.product_name ASC')

    @total_products = @order_items.length

    @total_quantity = base_scope.sum(:quantity)

    @total_orders = @order_batch.orders.count

    render layout: 'print_orders'
  end

  private

  def order_params
    params.require(:order).permit(
      :order_number,
      :tracking_number,
      :courier_service_id,
      order_items_attributes: %i[
        id
        product_id
        variant
        quantity
        _destroy
      ]
    )
  end

  def duplicate_form_params
    params.require(:duplicate_orders_form).permit(
      :product_id,
      :variant,
      :quantity,
      :courier_service_id,
      :duplicate_count
    )
  end

  def extract_orders_params
    return [] unless params[:orders]

    params[:orders].values.map do |row|
      {
        order_number: row[:order_number],
        tracking_number: row[:tracking_number]
      }
    end
  end

  def merchant_scope
    Merchant.find_by!(
      id: params[:merchant_order_id],
      is_active: true,
      deleted_at: nil
    )
  end

  def order_batch_scope
    merchant_scope
      .order_batches
      .includes(:user_created)
      .find_by!(
        id: params[:order_batch_id],
        deleted_at: nil
      )
  end

  def order_scope
    order_batch_scope
      .orders
      .with_total_items
      .includes(:courier_service, :order_items)
      .find_by!(
        id: params[:id],
        deleted_at: nil
      )
  end

  def order_preparing_scope
    order_batch_scope
      .orders
      .with_total_items
      .includes(:courier_service, order_items: :product)
      .find_by!(
        id: params[:id],
        status: :preparing,
        deleted_at: nil
      )
  end

  def assign_dropdown_search_labels(order)
    @courier_service_label = order.courier_service&.name
  end
end
