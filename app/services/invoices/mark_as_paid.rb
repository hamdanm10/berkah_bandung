# frozen_string_literal: true

class Invoices::MarkAsPaid < ApplicationService
  def call(invoice:)
    return failure(message: "Invoice is already mark as paid.") if invoice.paid?
    return failure(message: "Only posted invoice can be paid") unless invoice.posted?

    if invoice.update_columns(invoice_status: "paid", remarks: nil)
      success(
        invoice: invoice,
        message: "Invoice has been successfully mark as paid."
      )
    else
      failure(invoice: invoice)
    end
  end
end
