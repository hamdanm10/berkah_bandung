# frozen_string_literal: true

class Invoices::Update < ApplicationService
  def call(invoice:, invoice_params:)
    invoice.assign_attributes(invoice_params)

    if invoice.save
      success(
        invoice: invoice,
        message: "Invoice was successfully updated."
      )
    else
      failure(invoice: invoice)
    end
  end
end
