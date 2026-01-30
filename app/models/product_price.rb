# frozen_string_literal: true

class ProductPrice < ApplicationRecord
  # Relations
  belongs_to :product
  has_many :invoice_items

  # Instance Methods
  def total_value
    quantity * cost_price
  end


  # Validations
  validates :quantity, presence: true, numericality: { only_integer: true }
  validates :cost_price,
            presence: true,
            numericality: {
              greater_than_or_equal_to: 0,
              less_than_or_equal_to: 999_000_000
            },
            uniqueness: { scope: :product_id }
end
