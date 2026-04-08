# frozen_string_literal: true

class Invoices::Create < ApplicationService
  def call(invoice_params:)
    invoice = Invoice.new(invoice_params)
    invoice.created_by_user_id = Current.user.id

    ActiveRecord::Base.transaction do
      result = Invoices::AdjustStock.call(
        items: invoice.invoice_items,
        invoice_type: invoice.invoice_type
      )

      return failure(invoice: invoice) unless result[:success]

      return failure(invoice: invoice) unless invoice.save
    end

    success(invoice: invoice, message: 'Invoice was successfully created.')
  end
end
