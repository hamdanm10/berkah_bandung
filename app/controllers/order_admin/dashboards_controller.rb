# frozen_string_literal: true

class OrderAdmin::DashboardsController < OrderAdminApplicationController
  def show
    today = Time.current.all_day

    orders = Order
             .joins(:order_batch)
             .where(deleted_at: nil)
             .where(order_batches: { created_by_user_id: Current.user.id })

    @orders_added_today = orders.where(created_at: today).count

    @delivered_today = orders
                       .where(status: 'delivered', delivered_at: today)
                       .count

    @pending_orders = orders
                      .where(status: 'preparing')
                      .count

    @total_orders = orders.count

    @orders_by_status = orders.group(:status).count

    @recent_orders = orders
                     .select(:order_number, :tracking_number, :status)
                     .order(created_at: :desc)
                     .limit(10)
  end
end
