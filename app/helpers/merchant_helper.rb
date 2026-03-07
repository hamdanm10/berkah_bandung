# frozen_string_literal: true

module MerchantHelper
  def merchant_statuses_for_select
    merchant_statuses = [
      { name: 'Active', status: true },
      { name: 'Inactive', status: false }
    ]

    merchant_statuses.map do |merchant_status|
      [merchant_status[:name].titleize, merchant_status[:status]]
    end
  end

  def merchants_for_select
    Merchant.where(is_active: true, deleted_at: nil).order(name: :asc).map do |merchant|
      [merchant.name, merchant.id]
    end
  end
end
