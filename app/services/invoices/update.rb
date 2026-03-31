# frozen_string_literal: true

class Invoices::Update < ApplicationService
  def call(invoice:, invoice_params:)
    ActiveRecord::Base.transaction do
      result = Invoices::AdjustStock.call(
        items: invoice.invoice_items,
        invoice_type: invoice.invoice_type,
        reverse: true
      )

      unless result[:success]
        invoice.errors.add(:base, result[:error].join(', '))
        return failure(invoice: invoice)
      end

      invoice.assign_attributes(invoice_params)

      result = Invoices::AdjustStock.call(
        items: invoice.invoice_items,
        invoice_type: invoice.invoice_type
      )

      return failure(invoice: invoice) unless result[:success]

      return failure(invoice: invoice) unless invoice.save
    end

    success(invoice: invoice, message: 'Invoice was successfully updated.')
  end
end
