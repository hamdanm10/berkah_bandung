# frozen_string_literal: true

class OrderItemReturnedDetail < ApplicationRecord
  # ============================
  # Relations
  # ============================
  belongs_to :order_status, polymorphic: true
  belongs_to :order_item_return
end
