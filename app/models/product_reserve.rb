# frozen_string_literal: true

class ProductReserve < ApplicationRecord
  # ============================
  # Relations
  # ============================
  belongs_to :product
end
