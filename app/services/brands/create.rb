# frozen_string_literal: true

class Brands::Create < ApplicationService
  def call(brand_params:)
    brand = Brand.new(
      brand_params.merge(
        is_active: true
      )
    )

    if brand.save
      success(
        brand: brand,
        message: "Brand was successfully created."
      )
    else
      failure(brand: brand)
    end
  end
end
