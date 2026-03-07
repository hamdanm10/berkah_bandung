# frozen_string_literal: true

class Products::Update < ApplicationService
  def call(product:, product_params:)
    update_product!(product, product_params)

    success(
      product: product,
      message: 'Product was successfully updated.'
    )
  rescue ActiveRecord::RecordInvalid
    failure(product: product)
  end

  private

  def update_product!(product, params)
    product.update!(params)
  end
end
