# frozen_string_literal: true

class Products::Activate < ApplicationService
  def call(product:)
    return failure(message: 'Product is already active.') if product.is_active?

    activate!(product)

    success(
      product: product,
      message: 'Product has been successfully activated.'
    )
  rescue ActiveRecord::RecordInvalid
    failure(product: product)
  end

  private

  def activate!(product)
    product.update!(is_active: true)
  end
end
