# frozen_string_literal: true

class InvoiceItem < ApplicationRecord
  # Enums
  enum :adjustment_type, {
    increase: 0,
    decrease: 1
  }

  # Relations
  belongs_to :invoice
  belongs_to :product
  belongs_to :product_price, optional: true

  # Callbacks
  before_validation :normalize_adjustment_type

  # Validations
  validates :product_id, presence: true
  validates :quantity, presence: true, numericality: { only_integer: true }
  validates :cost_snapshot,
            presence: true,
            numericality: {
              greater_than_or_equal_to: 0,
              less_than_or_equal_to: 999_000_000
            }

  validates :adjustment_type,
            presence: true,
            if: -> { invoice&.adjustment? }

  validates :adjustment_type,
            absence: true,
            unless: -> { invoice&.adjustment? }

  private

  def normalize_adjustment_type
    return if invoice&.adjustment?

    self.adjustment_type = nil
  end
end
