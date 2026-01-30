# frozen_string_literal: true

class Products::Activate < ApplicationService
  def call(product:)
    return failure(message: "Product is already active.") if product.is_active?

    if product.update(is_active: true)
      success(
        product: product,
        message: "Product has been successfully activated."
      )
    else
      failure(product: product)
    end
  end
end
