# frozen_string_literal: true

class Brands::SoftDelete < ApplicationService
  def call(brand:)
    return failure(message: "Brand is already deleted.") if brand.deleted_at.present?

    if brand.update(
      deleted_at: Time.current,
      is_active: false
    )
      success(
        brand: brand,
        message: "Brand has been successfully deleted."
      )
    else
      failure(brand: brand)
    end
  end
end
