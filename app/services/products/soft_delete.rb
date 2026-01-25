# frozen_string_literal: true

class Products::SoftDelete < ApplicationService
  def call(product:)
    return failure(message: "Product is already deleted.") if product.deleted_at.present?

    if product.update(
      deleted_at: Time.current,
      is_active: false
    )
      success(
        product: product,
        message: "Product has been successfully deleted."
      )
    else
      failure(product: product)
    end
  end
end
