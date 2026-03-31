# frozen_string_literal: true

class InvoiceItem < ApplicationRecord
  belongs_to :invoice
  belongs_to :product
  belongs_to :product_available

  validates :product_id, presence: true
  validates :quantity, presence: true, numericality: { only_integer: true }
  validates :cost_snapshot,
            presence: true,
            numericality: {
              greater_than_or_equal_to: 0,
              less_than_or_equal_to: 999_000_000
            }
end
