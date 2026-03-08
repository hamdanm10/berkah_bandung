# frozen_string_literal: true

class SuperAdmin::ProductsController < SuperAdminApplicationController
  def index
    limit = RecordLimit.call(params[:limit])

    @q = Product
         .where(deleted_at: nil)
         .ransack(params[:q])

    @products = @q
                .result
                .with_total_quantity
                .includes(:category, :brand)
                .order(name: :asc)

    @pagy, @products = pagy(@products, limit:)
  end

  def show
    @product = product_details_scope
  end

  def new
    @product = Product.new
    assign_dropdown_search_labels(@product)
  end

  def create
    result = Products::Create.call(
      product_params: product_params
    )

    if result.success?
      redirect_to new_super_admin_product_path, notice: result.payload[:message]
    else
      @product = result.error[:product]
      assign_dropdown_search_labels(@product)

      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @product = product_scope
    assign_dropdown_search_labels(@product)
  end

  def update
    result = Products::Update.call(
      product: product_scope,
      product_params: product_params
    )

    if result.success?
      product = result.payload[:product]

      redirect_to edit_super_admin_product_path(product), notice: result.payload[:message]
    else
      @product = result.error[:product]
      assign_dropdown_search_labels(@product)

      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    result = Products::SoftDelete.call(
      product: product_scope
    )

    if result.success?
      redirect_to super_admin_products_path, notice: result.payload[:message]
    else
      redirect_to super_admin_products_path, alert: result.error[:product]
    end
  end

  def activate
    result = Products::Activate.call(
      product: product_scope
    )

    if result.success?
      redirect_to super_admin_products_path, notice: result.payload[:message]
    else
      redirect_to super_admin_products_path, alert: result.error[:product]
    end
  end

  def deactivate
    result = Products::Deactivate.call(
      product: product_scope
    )

    if result.success?
      redirect_to super_admin_products_path, notice: result.payload[:message]
    else
      redirect_to super_admin_products_path, alert: result.error[:product]
    end
  end

  # def import
  #   @product_import = ProductImportForm.new
  # end

  # def create_import
  #   result = Products::Import.call(
  #     product_import_params: product_import_params
  #   )

  #   if result.success?
  #     redirect_to import_super_admin_products_path, notice: result.payload[:message]
  #   else
  #     @product_import = result.error[:product_import] || ProductImportForm.new
  #     @import_errors = result.error[:import_errors]

  #     render :import, status: :unprocessable_entity
  #   end
  # end

  # def download_import_template
  #   file_path = Rails.root.join(
  #     'public',
  #     'templates',
  #     'product_import_template.xlsx'
  #   )

  #   send_file file_path,
  #             filename: 'product_import_template.xlsx',
  #             type: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
  #             disposition: 'attachment'
  # end

  private

  def product_params
    params.require(:product).permit(
      :code,
      :barcode,
      :name,
      :category_id,
      :brand_id
    )
  end

  def product_import_params
    params.require(:product_import_form).permit(
      :file
    )
  end

  def product_scope
    Product
      .includes(:category, :brand, :product_availables)
      .find_by!(
        id: params[:id],
        deleted_at: nil
      )
  end

  def product_details_scope
    Product
      .with_total_quantity
      .includes(:category, :brand, :product_availables)
      .find_by!(
        id: params[:id],
        deleted_at: nil
      )
  end

  def assign_dropdown_search_labels(product)
    @category_label = product.category&.name
    @brand_label = product.brand&.name
  end
end
