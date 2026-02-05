# frozen_string_literal: true

class Products::SoftDelete < ApplicationService
  def call(product:)
    return failure(message: 'Product is already deleted.') if product.deleted_at?

    soft_delete!(product)

    success(
      product: product,
      message: 'Product has been successfully deleted.'
    )
  rescue ActiveRecord::RecordInvalid
    failure(product: product)
  end

  private

  def soft_delete!(product)
    product.update!(
      deleted_at: Time.current,
      is_active: false
    )
  end
end
