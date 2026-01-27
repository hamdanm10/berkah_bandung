# frozen_string_literal: true

class Invoices::Create < ApplicationService
  def call(invoice_params:)
    invoice = Invoice.new(
      invoice_params.merge(
        invoice_status: "draft"
      )
    )

    if invoice.save
      success(
        invoice: invoice,
        message: "Invoice was successfully created."
      )
    else
      failure(invoice: invoice)
    end
  end
end
