# frozen_string_literal: true

class OrderAdmin::OrderBatchesController < OrderAdminApplicationController
  def index
    @merchant = merchant_scope

    limit = RecordLimit.call(params[:limit])

    @q = @merchant.order_batches.where(deleted_at: nil, created_by_user_id: current_user.id).ransack(params[:q])
    @order_batches = @q.result.includes(:user_created).order(created_at: :desc)
    @pagy, @order_batches = pagy(@order_batches, limit:)
  end

  def new
    @merchant = merchant_scope
    @order_batch = OrderBatch.new
  end

  def create
    @merchant = merchant_scope

    result = OrderBatches::Create.call(
      merchant: @merchant,
      order_batch_params: order_batch_params
    )

    if result.success?
      redirect_to new_order_admin_merchant_order_order_batch_path(@merchant), notice: result.payload[:message]
    else
      @order_batch = result.error[:order_batch]

      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @merchant = merchant_scope
    @order_batch = order_batch_scope
  end

  def update
    @merchant = merchant_scope

    result = OrderBatches::Update.call(
      order_batch: order_batch_scope,
      order_batch_params: order_batch_params
    )

    if result.success?
      order_batch = result.payload[:order_batch]

      redirect_to edit_order_admin_merchant_order_order_batch_path(@merchant, order_batch),
                  notice: result.payload[:message]
    else
      @order_batch = result.error[:order_batch]

      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @merchant = merchant_scope

    result = OrderBatches::SoftDelete.call(
      order_batch: order_batch_scope
    )

    if result.success?
      redirect_to order_admin_merchant_order_order_batches_path(@merchant), notice: result.payload[:message]
    else
      redirect_to order_admin_merchant_order_order_batches_path(@merchant), alert: result.error[:order_batch]
    end
  end

  private

  def order_batch_params
    params.require(:order_batch).permit(:code)
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
      .find_by!(
        id: params[:id],
        created_by_user_id: current_user.id,
        deleted_at: nil
      )
  end
end
