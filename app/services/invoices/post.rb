# frozen_string_literal: true

class Invoices::Post < ApplicationService
  def call(invoice:)
    return failure(message: "Invoice is already posted.") if invoice.posted?
    return failure(message: "Only draft invoice can be posted.") unless invoice.draft?

    ActiveRecord::Base.transaction do
      invoice.invoice_items.includes(:product, :product_price).find_each do |item|
        product = item.product

        DistributorItem.find_or_create_by!(
          distributor_id: invoice.distributor_id,
          product_id: product.id
        )

        product_price = ProductPrice.find_by(
          product_id: product.id,
          cost_price: item.cost_snapshot
        )

        unless product_price
          product_price = ProductPrice.create!(
            product_id: product.id,
            cost_price: item.cost_snapshot,
            quantity: 0
          )
        end

        item.update_columns(product_price_id: product_price.id)

        quantity_delta = calculate_quantity_delta(invoice, item)

        product_price.update!(
          quantity: product_price.quantity + quantity_delta
        )
      end

      invoice.update_columns(
        invoice_status: Invoice.invoice_statuses[:posted],
      )
    end

    success(
      invoice: invoice,
      message: "Invoice has been successfully posted."
    )
  rescue ActiveRecord::RecordInvalid => e
    failure(message: e.message)
  end

  private

  def calculate_quantity_delta(invoice, item)
    qty = item.quantity

    case invoice.invoice_type.to_sym
    when :normal
      qty

    when :return
      -qty

    when :adjustment
      case item.adjustment_type&.to_sym
      when :increase
        qty
      when :decrease
        -qty
      else
        raise ActiveRecord::RecordInvalid, "Invalid adjustment type"
      end

    else
      raise ActiveRecord::RecordInvalid, "Invalid invoice type"
    end
  end
end
