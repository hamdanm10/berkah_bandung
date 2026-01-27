# frozen_string_literal: true

module InvoiceHelper
  def invoice_statuses_for_select
    Invoice.invoice_statuses
      .map { |invoice_status, value| [ invoice_status.titleize, invoice_status ] }
  end

  def invoice_types_for_select
    Invoice.invoice_types
      .map { |invoice_type, value| [ invoice_type.titleize, invoice_type ] }
  end
end
