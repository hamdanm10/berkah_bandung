# frozen_string_literal: true

module InvoiceHelper
  def invoice_types_for_select
    Invoice.invoice_types
           .map { |invoice_type, _value| [invoice_type.titleize, invoice_type] }
  end

  def value_invoice_types_for_select
    Invoice.invoice_types
           .map { |invoice_type, value| [invoice_type.titleize, value] }
  end
end
