# frozen_string_literal: true

class Merchants::SoftDelete < ApplicationService
  def call(merchant:)
    return failure(message: "Merchant is already deleted.") if merchant.deleted_at.present?

    if merchant.update(
      deleted_at: Time.current,
      is_active: false
    )
      success(
        merchant: merchant,
        message: "Merchant has been successfully deleted."
      )
    else
      failure(merchant: merchant)
    end
  end
end
