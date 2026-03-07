# frozen_string_literal: true

module ProductHelper
  def product_statuses_for_select
    product_statuses = [
      { name: 'Active', status: true },
      { name: 'Inactive', status: false }
    ]

    product_statuses.map do |product_status|
      [product_status[:name].titleize, product_status[:status]]
    end
  end
end
