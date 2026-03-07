# frozen_string_literal: true

class OrderItemReturnedDetail < ApplicationRecord
  # ============================
  # Relations
  # ============================
  belongs_to :order_item_return
  belongs_to :order_item_filled_detail

  # ============================
  # Validations
  # ============================
  validates :order_item_return_id, presence: true
  validates :order_item_filled_detail_id, presence: true
  validates :good_stock, presence: true
  validates :bad_stock, presence: true
end
