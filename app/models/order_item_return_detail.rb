# frozen_string_literal: true

class OrderItemReturnDetail < ApplicationRecord
  # ============================
  # Enums
  # ============================

  # ============================
  # Relations
  # ============================
  belongs_to :order_status, polymorphic: true

  # ============================
  # Validations
  # ============================
end
