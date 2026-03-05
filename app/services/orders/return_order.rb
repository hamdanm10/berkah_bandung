# frozen_string_literal: true

class Orders::ReturnOrder < ApplicationService
  def call(order:, return_params:)
    ActiveRecord::Base.transaction do
      validate_order!(order)

      items_params = return_params[:items] || {}

      order.order_items.includes(
        order_item_filled_details: :product_available
      ).each do |order_item|
        item_param = items_params[order_item.id.to_s]
        raise "Missing return data for order item #{order_item.id}" unless item_param

        process_order_item_return!(order_item, item_param)
      end

      order.update!(
        status: 'returned',
        returned_by_id: Current.user.id,
        returned_at: Time.current
      )

      success(order: order, message: 'Order was successfully returned.')
    end
  rescue StandardError
    failure(order: order)
  end

  private

  def validate_order!(order)
    raise 'Order not found' unless order
    raise 'Only delivered order can be returned' unless order.status == 'delivered'
  end

  def process_order_item_return!(order_item, item_param)
    quantity   = order_item.quantity
    good_stock = item_param[:good_stock].to_i
    bad_stock  = quantity - good_stock

    raise 'Invalid good stock value' if good_stock < 0 || good_stock > quantity

    order_item_return = order_item.create_order_item_return!(
      good_stock: good_stock,
      bad_stock: bad_stock
    )

    remaining_bad  = bad_stock
    remaining_good = good_stock

    filled_details = order_item.order_item_filled_details
                               .joins(:product_available)
                               .order('product_availables.cost_price ASC')

    bad_map = {}

    filled_details.each do |filled|
      break if remaining_bad <= 0

      used_bad = [filled.quantity, remaining_bad].min

      bad_map[filled.id] = used_bad

      remaining_bad -= used_bad
    end

    filled_details.each do |filled|
      break if remaining_good <= 0

      used_bad = bad_map[filled.id] || 0
      layer_qty = filled.quantity

      available = layer_qty - used_bad
      next if available <= 0

      used_good = [available, remaining_good].min

      filled.product_available.increment!(:quantity, used_good) if used_good > 0

      order_item_return.order_item_returned_details.create!(
        order_item_filled_detail: filled,
        good_stock: used_good,
        bad_stock: used_bad
      )

      remaining_good -= used_good
    end
  end
end
