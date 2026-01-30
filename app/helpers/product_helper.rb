# frozen_string_literal: true

module ProductHelper
  def product_statuses_for_select
    product_statuses = [
      { name: "Active", status: true },
      { name: "Inactive", status: false }
    ]

    product_statuses.map do |product_status|
      [ product_status[:name].titleize, product_status[:status] ]
    end
  end

  def categories_for_select
    Category.where(is_active: true, deleted_at: nil).order(name: :asc).map do |category|
      [ category.name.titleize, category.id ]
    end
  end

  def brands_for_select
    Brand.where(is_active: true, deleted_at: nil).order(name: :asc).map do |brand|
      [ brand.name, brand.id ]
    end
  end

  def distributors_for_select
    Distributor.where(is_active: true, deleted_at: nil).order(name: :asc).map do |distributor|
      [ distributor.name, distributor.id ]
    end
  end
end
