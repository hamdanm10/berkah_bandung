# frozen_string_literal: true

class ProductAvailables::Create < ApplicationService
  def call(product_available_params:, product:)
    product_available = ProductAvailable.new(product_available_params)
    product_available.product_id = product.id

    if product_available.save
      success(
        product_available: product_available,
        message: 'Product available was successfully created.'
      )
    else
      failure(product_available: product_available)
    end
  end
end
