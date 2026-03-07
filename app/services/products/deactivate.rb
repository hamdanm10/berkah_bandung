# frozen_string_literal: true

class Products::Deactivate < ApplicationService
  def call(product:)
    return failure(message: 'Product is already inactive.') unless product.is_active?

    deactivate!(product)

    success(
      product: product,
      message: 'Product has been successfully deactivated.'
    )
  rescue ActiveRecord::RecordInvalid
    failure(product: product)
  end

  private

  def deactivate!(product)
    product.update!(is_active: false)
  end
end
