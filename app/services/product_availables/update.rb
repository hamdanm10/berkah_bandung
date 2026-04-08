# frozen_string_literal: true

class ProductAvailables::Update < ApplicationService
  def call(product_available:, product_available_params:)
    product_available.assign_attributes(product_available_params)

    if product_available.save
      success(
        product_available: product_available,
        message: 'Product available was successfully updated.'
      )
    else
      failure(product_available: product_available)
    end
  end
end
