# frozen_string_literal: true

module MerchantHelper
  def merchant_statuses_for_select
    merchant_statuses = [
      { name: "Active", status: true },
      { name: "Inactive", status: false }
    ]

    merchant_statuses.map do |merchant_status|
      [ merchant_status[:name].titleize, merchant_status[:status] ]
    end
  end
end
