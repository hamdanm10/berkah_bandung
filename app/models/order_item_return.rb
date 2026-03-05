# frozen_string_literal: true

class OrderItemReturn < ApplicationRecord
  # ============================
  # Relations
  # ============================
  belongs_to :order_item
  has_many :order_item_returned_details

  # ============================
  # Validations
  # ============================
  validates :order_item_id, presence: true
  validates :good_stock, presence: true
  validates :bad_stock, presence: true
end
