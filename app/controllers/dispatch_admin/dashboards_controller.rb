# frozen_string_literal: true

class DispatchAdmin::DashboardsController < DispatchAdminApplicationController
  def show
    today = Time.current.all_day

    orders = Order.where(deleted_at: nil)

    orders_today = orders.where(created_at: today).count

    @orders_today = orders_today

    @delivered_today = orders.where(status: 'delivered', delivered_at: today).count
    @pending_orders = orders.where(status: 'preparing').count

    @orders_by_courier_today = orders
                               .joins(:courier_service)
                               .where(created_at: today)
                               .group('courier_services.name')
                               .count

    @recent_orders = orders
                     .where(status: 'delivered')
                     .select(:order_number, :tracking_number)
                     .order(created_at: :desc)
                     .limit(10)
  end
end
