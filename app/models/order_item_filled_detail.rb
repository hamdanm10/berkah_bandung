# frozen_string_literal: true

class OrderItemFilledDetail < ApplicationRecord
  # ============================
  # Relations
  # ============================
  belongs_to :order_item
  belongs_to :product_available

  # ============================
  # Validations
  # ============================
  validates :order_item_id, presence: true
  validates :product_available_id, presence: true
  validates :quantity, presence: true, numericality: { greater_than: 0 }
end
