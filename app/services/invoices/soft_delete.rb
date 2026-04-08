# frozen_string_literal: true

class Invoices::SoftDelete < ApplicationService
  def call(invoice:)
    ActiveRecord::Base.transaction do
      result = Invoices::AdjustStock.call(
        items: invoice.invoice_items,
        invoice_type: invoice.invoice_type,
        reverse: true
      )

      return failure(invoice: invoice) unless result[:success]

      return failure(invoice: invoice) unless invoice.update(deleted_at: Time.current)
    end

    success(invoice: invoice, message: 'Invoice deleted')
  end
end
