# frozen_string_literal: true

class Invoices::SoftDelete < ApplicationService
  def call(invoice:)
    return failure(message: "Invoice is already deleted.") if invoice.deleted_at.present?
    return failure(message: "Invoice cannot be deleted because it has already been posted or paid.") if invoice.posted? || invoice.paid?

    if invoice.update_column(
      :deleted_at, Time.current,
    )
      success(
        invoice: invoice,
        message: "Invoice has been successfully deleted."
      )
    else
      failure(invoice: invoice)
    end
  end
end
