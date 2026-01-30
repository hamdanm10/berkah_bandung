# frozen_string_literal: true

class Invoices::Create < ApplicationService
  def call(invoice_params:)
    invoice = Invoice.new(invoice_params)
    invoice.invoice_status = "draft"
    invoice.created_by_user_id = Current.user.id

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
