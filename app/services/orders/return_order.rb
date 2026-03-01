# frozen_string_literal: true

class Orders::ReturnOrder < ApplicationService
  def call(order:, return_params:)
    ActiveRecord::Base.transaction do
      validate_order!(order)

      items_params = return_params[:items] || {}

      order.order_items.includes(
        order_item_filled_details: :product_available,
        order_item_reserved_detail: []
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

      success(order: order)
    end
  rescue StandardError => e
    Rails.logger.error '===== RETURN ERROR ====='
    Rails.logger.error e.class.name
    Rails.logger.error e.message
    Rails.logger.error e.backtrace.first(5)
    raise e
  end

  private

  def validate_order!(order)
    raise 'Order not found' unless order
    raise 'Only delivered order can be returned' unless order.status == 'delivered'
  end

  def process_order_item_return!(order_item, item_param)
    quantity   = order_item.quantity.to_i
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

    # ===============================
    # BAD STOCK FIRST
    # ===============================
    filled_details.each do |filled|
      break if remaining_bad <= 0

      layer_qty = filled.quantity.to_i
      used_bad  = [layer_qty, remaining_bad].min

      create_detail(order_item_return, filled, 0, used_bad)

      remaining_bad -= used_bad
    end

    if remaining_bad > 0 && order_item.order_item_reserved_detail.present?
      reserved = order_item.order_item_reserved_detail
      used_bad = [reserved.quantity.to_i, remaining_bad].min

      create_detail(order_item_return, reserved, 0, used_bad)

      remaining_bad -= used_bad
    end

    # ===============================
    # GOOD STOCK
    # ===============================
    filled_details.each do |filled|
      break if remaining_good <= 0

      used_bad = total_bad_for(order_item_return, filled)
      available_qty = filled.quantity.to_i - used_bad
      next if available_qty <= 0

      used_good = [available_qty, remaining_good].min

      filled.product_available.increment!(:quantity, used_good)

      create_detail(order_item_return, filled, used_good, 0)

      remaining_good -= used_good
    end

    return unless remaining_good > 0 && order_item.order_item_reserved_detail.present?

    reserved = order_item.order_item_reserved_detail
    used_bad = total_bad_for(order_item_return, reserved)
    available_qty = reserved.quantity.to_i - used_bad

    used_good = [available_qty, remaining_good].min

    order_item.product.product_reserve.increment!(:quantity, used_good)

    create_detail(order_item_return, reserved, used_good, 0)

    remaining_good -= used_good
  end

  def create_detail(order_item_return, status_record, good, bad)
    order_item_return.order_item_returned_details.create!(
      order_status: status_record,
      good_stock: good,
      bad_stock: bad
    )
  end

  def total_bad_for(order_item_return, status_record)
    order_item_return.order_item_returned_details
                     .where(order_status: status_record)
                     .sum(:bad_stock)
  end
end
