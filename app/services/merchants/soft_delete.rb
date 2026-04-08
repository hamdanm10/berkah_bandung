# frozen_string_literal: true

class Merchants::SoftDelete < ApplicationService
  def call(merchant:)
    return failure(message: 'Merchant is already deleted.') if merchant.deleted_at.present?

    ActiveRecord::Base.transaction do
      merchant.scan_sound.purge_later if merchant.scan_sound.attached?

      unless merchant.update(
        deleted_at: Time.current,
        is_active: false
      )
        return failure(merchant: merchant)
      end
    end

    success(
      merchant: merchant,
      message: 'Merchant has been successfully deleted.'
    )
  end
end
