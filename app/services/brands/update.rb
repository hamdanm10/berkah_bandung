# frozen_string_literal: true

class Brands::Update < ApplicationService
  def call(brand:, brand_params:)
    brand.assign_attributes(brand_params)

    if brand.save
      success(
        brand: brand,
        message: "Brand was successfully updated."
      )
    else
      failure(brand: brand)
    end
  end
end
