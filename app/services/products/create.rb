# frozen_string_literal: true

class Products::Create < ApplicationService
  def call(product_params:)
    product = Product.new(
      product_params.merge(
        is_active: true
      )
    )

    if product.save
      success(
        product: product,
        message: "Product was successfully created."
      )
    else
      failure(product: product)
    end
  end
end
