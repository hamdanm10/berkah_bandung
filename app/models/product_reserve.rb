# frozen_string_literal: true

class ProductReserve < ApplicationRecord
  # ============================
  # Relations
  # ============================
  belongs_to :product

  # ============================
  # Validations
  # ============================
  validates :product_id, presence: true
  validates :quantity, presence: true, numericality: { greater_than_or_equal_to: 0 }
end
