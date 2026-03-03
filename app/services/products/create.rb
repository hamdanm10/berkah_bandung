# frozen_string_literal: true

class Products::Create < ApplicationService
  def call(product_params:)
    product = build_product(product_params)

    product.save!

    success(product: product, message: 'Product was successfully created.')
  rescue ActiveRecord::RecordInvalid
    failure(product: product)
  end

  private

  def build_product(params)
    Product.new(params.merge(is_active: true))
  end
end
