# frozen_string_literal: true

class ReturnAdmin::DashboardsController < ReturnAdminApplicationController
  def show
    today = Time.current.all_day
    orders = Order.where(deleted_at: nil)

    @cancelled_today = orders.where(status: 'cancelled', cancelled_at: today).count
    @returned_today = orders.where(status: 'returned', returned_at: today).count

    @recent_cancelled_orders = orders
                               .where(status: 'cancelled')
                               .select(:order_number, :tracking_number)
                               .order(created_at: :desc)
                               .limit(10)

    @recent_returned_orders = orders
                              .where(status: 'returned')
                              .select(:order_number, :tracking_number)
                              .order(created_at: :desc)
                              .limit(10)
  end
end
