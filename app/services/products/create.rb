# frozen_string_literal: true

class Products::Create < ApplicationService
  def call(product_params:)
    product = build_product(product_params)

    create_product!(product)

    success(product: product, message: 'Product was successfully created.')
  rescue ActiveRecord::RecordInvalid
    failure(product: product)
  end

  private

  def build_product(params)
    Product.new(params.merge(is_active: true))
  end

  def create_product!(product)
    ActiveRecord::Base.transaction do
      product.save!
      product.create_product_reserve!(quantity: 0)
    end
  end
end
