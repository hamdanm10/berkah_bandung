# frozen_string_literal: true

class SuperAdmin::StockAdjustmentsController < SuperAdminApplicationController
  def index
    limit = RecordLimit.call(params[:limit])

    @product = product

    @q = product_availables.ransack(params[:q])
    @product_availables = @q.result.order(created_at: :desc)
    @pagy, @product_availables = pagy(@product_availables, limit:)
  end

  def new
    @product_available = ProductAvailable.new
    @product = product
  end

  def create
    @product = product

    result = ProductAvailables::Create.call(
      product_available_params: product_available_params,
      product: @product
    )

    if result.success?
      redirect_to new_super_admin_product_stock_adjustment_path(@product), notice: result.payload[:message]
    else
      @product_available = result.error[:product_available]

      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @product = product
    @product_available = product_available
  end

  def update
    @product = product

    result = ProductAvailables::Update.call(
      product_available: product_available,
      product_available_params: product_available_params
    )

    if result.success?
      product_available = result.payload[:product_available]

      redirect_to edit_super_admin_product_stock_adjustment_path(@product, product_available),
                  notice: result.payload[:message]
    else
      @product_available = result.error[:product_available]

      render :edit, status: :unprocessable_entity
    end
  end

  private

  def product_available_params
    params.require(:product_available).permit(
      :cost_price,
      :quantity
    )
  end

  def product
    Product.find(params[:product_id])
  end

  def product_available
    product.product_availables.find(params[:id])
  end

  def product_availables
    product.product_availables.order(cost_price: :asc)
  end
end
