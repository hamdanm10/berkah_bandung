# frozen_string_literal: true

class Merchants::Update < ApplicationService
  def call(merchant:, merchant_params:)
    merchant.assign_attributes(merchant_params)

    if merchant.save
      success(
        merchant: merchant,
        message: "Merchant was successfully updated."
      )
    else
      failure(merchant: merchant)
    end
  end
end
