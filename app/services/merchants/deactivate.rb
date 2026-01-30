# frozen_string_literal: true

class Merchants::Deactivate < ApplicationService
  def call(merchant:)
    return failure(message: "Merchant is already inactive.") unless merchant.is_active?

    if merchant.update(is_active: false)
      success(
        merchant: merchant,
        message: "Merchant has been successfully deactivated."
      )
    else
      failure(merchant: merchant)
    end
  end
end
