# frozen_string_literal: true

class OrderItemFilledDetail < ApplicationRecord
  # ============================
  # Relations
  # ============================
  belongs_to :order_item
  belongs_to :product_available
  belongs_to :order_item_reserved_detail, optional: true
  has_many :order_item_return_details, as: :order_status

  # ============================
  # Validations
  # ============================
  validates :order_item_id, presence: true
  validates :product_available_id, presence: true
  validates :order_item_reserved_detail_id, presence: false
  validates :quantity, presence: true, numericality: { greater_than: 0 }
end
