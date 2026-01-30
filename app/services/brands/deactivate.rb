# frozen_string_literal: true

class Brands::Deactivate < ApplicationService
  def call(brand:)
    return failure(message: "Brand is already inactive.") unless brand.is_active?

    if brand.update(is_active: false)
      success(
        brand: brand,
        message: "Brand has been successfully deactivated."
      )
    else
      failure(brand: brand)
    end
  end
end
