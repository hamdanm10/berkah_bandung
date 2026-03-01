# frozen_string_literal: true

class OrderItemReturn < ApplicationRecord
  # ============================
  # Relations
  # ============================
  belongs_to :order_item
  has_many :order_item_returned_details
end
