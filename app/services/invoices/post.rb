class Invoices::Post < ApplicationService
  def call(invoice:)
    return failure(message: "Invoice already posted") if invoice.posted?
    return failure(message: "Only draft invoice allowed") unless invoice.draft?

    ActiveRecord::Base.transaction do
      Invoices::ConsumeReservedStock.call(invoice: invoice)

      invoice.update!(
        invoice_status: :posted
      )
    end

    success(message: "Invoice successfully posted.")
  end
end
