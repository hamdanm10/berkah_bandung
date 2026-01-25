# frozen_string_literal: true

class SuperAdmin::ProductsController < SuperAdminApplicationController
  def index
    limit = RecordLimit.call(params[:limit])

    @q = Product
          .where(deleted_at: nil)
          .includes(:category, :brand, :distributor)
          .ransack(params[:q])
    @products = @q.result.order(name: :asc)
    @pagy, @products = pagy(@products, limit:)
  end

  def new
    @product = Product.new
    @product.product_prices.build
  end

  def create
    result = Products::Create.call(
      product_params: product_params
    )

    if result.success?
      redirect_to new_super_admin_product_path, notice: result.payload[:message]
    else
      @product = result.error[:product]

      render :new, status: :unprocessable_entity
    end
  end

  private

  def product_params
    params.require(:product).permit(
      :code,
      :barcode,
      :name,
      :variant,
      :category_id,
      :brand_id,
      :distributor_id,
      product_prices_attributes: [
        :id,
        :quantity,
        :cost_price,
        :_destroy
      ]
    )
  end

  def product_scope
    Product.find(params[:id])
  end
end
