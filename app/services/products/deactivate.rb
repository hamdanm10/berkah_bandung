# frozen_string_literal: true

class Products::Deactivate < ApplicationService
  def call(product:)
    return failure(message: "Product is already inactive.") unless product.is_active?

    if product.update(is_active: false)
      success(
        product: product,
        message: "Product has been successfully deactivated."
      )
    else
      failure(product: product)
    end
  end
end
