# frozen_string_literal: true

class WarehouseAdmin::DashboardsController < WarehouseAdminApplicationController
  def show
    @total_products = Product.where(is_active: true).count
    @total_brands = Brand.where(is_active: true).count
    @total_categories = Category.where(is_active: true).count
    @total_distributors = Distributor.where(is_active: true).count

    @low_stock_products = Product
                          .with_total_quantity
                          .where('COALESCE(availables.sum_qty, 0) < ?', 10)
                          .order(Arel.sql('COALESCE(availables.sum_qty, 0) ASC'))
                          .limit(10)

    @top_products_this_month = OrderItem
                               .joins(:order, :product)
                               .where(orders: {
                                        deleted_at: nil,
                                        created_at: Time.current.beginning_of_month..Time.current.end_of_month
                                      })
                               .group('products.name')
                               .order('SUM(order_items.quantity) DESC')
                               .limit(10)
                               .sum('order_items.quantity')
  end
end
