# frozen_string_literal: true

class Products::Update < ApplicationService
  def call(product:, product_params:)
    product.assign_attributes(product_params)

    if product.save
      success(
        product: product,
        message: "Product was successfully updated."
      )
    else
      failure(product: product)
    end
  end
end
