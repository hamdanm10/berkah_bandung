# frozen_string_literal: true

class Brands::Activate < ApplicationService
  def call(brand:)
    return failure(message: "Brand is already active.") if brand.is_active?

    if brand.update(is_active: true)
      success(
        brand: brand,
        message: "Brand has been successfully activated."
      )
    else
      failure(brand: brand)
    end
  end
end
