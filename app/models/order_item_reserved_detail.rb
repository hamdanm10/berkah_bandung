# frozen_string_literal: true

class OrderItemReservedDetail < ApplicationRecord
  # ============================
  # Enums
  # ============================
  enum :status, {
    pending: 0,
    filled: 1
  }, default: :pending

  # ============================
  # Relations
  # ============================
  belongs_to :order_item
  has_one :order_item_filled_detail

  # ============================
  # Validations
  # ============================
  validates :order_item_id, presence: true
  validates :quantity, presence: true, numericality: { greater_than: 0 }
  validates :status, presence: true
end
