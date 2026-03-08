# frozen_string_literal: true

class OrderSupervisor::DashboardsController < OrderSupervisorApplicationController
  def show
    today = Time.current.all_day
    yesterday = 1.day.ago.all_day
    last_7_days = 6.days.ago.beginning_of_day..Time.current.end_of_day

    orders = Order.where(deleted_at: nil)

    orders_today = orders.where(created_at: today).count
    orders_yesterday = orders.where(created_at: yesterday).count

    @orders_today = orders_today
    @orders_change_percentage = calculate_percentage_change(orders_today, orders_yesterday)

    @paid_today = orders.where(status: 'paid', paid_at: today).count
    @delivered_today = orders.where(status: 'delivered', delivered_at: today).count
    @pending_orders = orders.where(status: 'preparing').count
    @cancelled_today = orders.where(status: 'cancelled', cancelled_at: today).count
    @returned_today = orders.where(status: 'returned', returned_at: today).count

    orders_last_7_days = orders.where(created_at: last_7_days)

    @orders_last_7_days = orders_last_7_days.count

    @orders_chart_last_7_days = orders_last_7_days
                                .group_by_day(:created_at, last: 7, format: '%a')
                                .count

    @total_orders = orders.count

    @orders_by_status = orders.group(:status).count

    @orders_by_courier_today = orders
                               .joins(:courier_service)
                               .where(created_at: today)
                               .group('courier_services.name')
                               .count

    @recent_orders = orders
                     .select(:order_number, :tracking_number, :status)
                     .order(created_at: :desc)
                     .limit(10)
  end

  private

  def calculate_percentage_change(today, yesterday)
    return 0 if yesterday.zero?

    (((today - yesterday).to_f / yesterday) * 100).round(2)
  end
end
