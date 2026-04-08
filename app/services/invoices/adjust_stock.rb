# frozen_string_literal: true

class Invoices::AdjustStock < ApplicationService
  def call(items:, invoice_type:, reverse: false)
    multiplier = invoice_type == 'return' ? -1 : 1
    multiplier *= -1 if reverse

    items.each do |item|
      product_available = ProductAvailable.find_by(
        product_id: item.product_id,
        cost_price: item.cost_snapshot
      )

      if product_available
        product_available.quantity += item.quantity * multiplier
      else
        product_available = ProductAvailable.new(
          product_id: item.product_id,
          cost_price: item.cost_snapshot,
          quantity: item.quantity * multiplier
        )
      end

      return { success: false, error: product_available.errors.full_messages } unless product_available.save

      item.product_available_id = product_available.id unless reverse
    end

    { success: true }
  end
end
