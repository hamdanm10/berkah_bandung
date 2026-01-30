# frozen_string_literal: true

class Merchants::Create < ApplicationService
  def call(merchant_params:)
    merchant = Merchant.new(
      merchant_params.merge(
        is_active: true
      )
    )

    if merchant.save
      success(
        merchant: merchant,
        message: "Merchant was successfully created."
      )
    else
      failure(merchant: merchant)
    end
  end
end
