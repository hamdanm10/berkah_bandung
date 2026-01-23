# frozen_string_literal: true

class Merchants::Activate < ApplicationService
  def call(merchant:)
    return failure(message: "Merchant is already active.") if merchant.is_active?

    if merchant.update(is_active: true)
      success(
        merchant: merchant,
        message: "Merchant has been successfully activated."
      )
    else
      failure(merchant: merchant)
    end
  end
end
