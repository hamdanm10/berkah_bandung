# frozen_string_literal: true

class ReturnOrderForm
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :order_id, :integer
  attribute :items, default: {}

  validate :order_must_exist
  validate :validate_each_item

  def order
    @order ||= Order.includes(order_items: :product).find_by(id: order_id)
  end

  def good_stock_for(item_id)
    items&.dig(item_id.to_s, 'good_stock')
  end

  def error_for(item_id)
    errors[:"items_#{item_id}_good_stock"]&.first
  end

  private

  def order_must_exist
    errors.add(:order_id, 'Order not found') unless order
  end

  def validate_each_item
    return unless order

    order.order_items.each do |order_item|
      item_id = order_item.id.to_s
      value   = items&.dig(item_id, 'good_stock')

      if value.blank?
        errors.add(:"items_#{item_id}_good_stock", 'This field is required')
        next
      end

      good_stock = value.to_i

      if good_stock < 0
        errors.add(:"items_#{item_id}_good_stock", 'Cannot be negative')
      elsif good_stock > order_item.quantity
        errors.add(
          :"items_#{item_id}_good_stock",
          "Cannot exceed available quantity (#{order_item.quantity})"
        )
      end
    end
  end
end
