# frozen_string_literal: true

class WarehouseAdmin::BrandsController < WarehouseAdminApplicationController
  def index
    limit = RecordLimit.call(params[:limit])

    @q = Brand.where(deleted_at: nil).ransack(params[:q])
    @brands = @q.result.order(created_at: :desc)
    @pagy, @brands = pagy(@brands, limit:)
  end

  def new
    @brand = Brand.new
  end

  def create
    result = Brands::Create.call(
      brand_params: brand_params
    )

    if result.success?
      redirect_to new_warehouse_admin_brand_path, notice: result.payload[:message]
    else
      @brand = result.error[:brand]

      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @brand = brand_scope
  end

  def update
    result = Brands::Update.call(
      brand: brand_scope,
      brand_params: brand_params
    )

    if result.success?
      brand = result.payload[:brand]

      redirect_to edit_warehouse_admin_brand_path(brand), notice: result.payload[:message]
    else
      @brand = result.error[:brand]

      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    result = Brands::SoftDelete.call(
      brand: brand_scope
    )

    if result.success?
      redirect_to warehouse_admin_brands_path, notice: result.payload[:message]
    else
      redirect_to warehouse_admin_brands_path, alert: result.error[:brand]
    end
  end

  def activate
    result = Brands::Activate.call(
      brand: brand_scope
    )

    if result.success?
      redirect_to warehouse_admin_brands_path, notice: result.payload[:message]
    else
      redirect_to warehouse_admin_brands_path, alert: result.error[:brand]
    end
  end

  def deactivate
    result = Brands::Deactivate.call(
      brand: brand_scope
    )

    if result.success?
      redirect_to warehouse_admin_brands_path, notice: result.payload[:message]
    else
      redirect_to warehouse_admin_brands_path, alert: result.error[:brand]
    end
  end

  private

  def brand_params
    params.require(:brand).permit(:name)
  end

  def brand_scope
    Brand.find(params[:id])
  end
end
