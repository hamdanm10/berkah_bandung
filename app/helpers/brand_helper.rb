# frozen_string_literal: true

module BrandHelper
  def brand_statuses_for_select
    brand_statuses = [
      { name: 'Active', status: true },
      { name: 'Inactive', status: false }
    ]

    brand_statuses.map do |brand_status|
      [brand_status[:name].titleize, brand_status[:status]]
    end
  end

  def brands_for_select
    Brand.where(is_active: true, deleted_at: nil).order(name: :asc).map do |brand|
      [brand.name, brand.id]
    end
  end
end
