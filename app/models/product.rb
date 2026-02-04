# frozen_string_literal: true

class Product < ApplicationRecord
  # Relations
  belongs_to :category
  belongs_to :brand

  has_many :product_prices
  has_many :invoice_items
  has_many :distributor_items
  has_many :orders

  # Ransack
  def self.ransackable_attributes(auth_object = nil)
    [ "code", "barcode", "name", "category_id", "brand_id", "is_active" ]
  end

  def self.ransackable_associations(auth_object = nil)
    []
  end

  # Normalization
  normalizes :code, with: ->(e) { e.to_s.strip.upcase }

  # Scopes
  scope :with_total_quantity, lambda {
    joins(<<~SQL)
      LEFT JOIN (
        SELECT
          product_id,
          SUM(quantity) AS total_quantity
        FROM product_prices
        GROUP BY product_id
      ) product_prices_sum
        ON product_prices_sum.product_id = products.id
    SQL
    .select(<<~SQL)
      products.*,
      (
        COALESCE(product_prices_sum.total_quantity, 0)
        - COALESCE(products.reserved_quantity, 0)
      ) AS total_quantity
    SQL
  }

  # Validations
  validates :code,
            presence: true,
            length: { maximum: 20 },
            format: {
              with: /\A[^\s]+\z/,
              message: "cannot contain spaces"
            },
            uniqueness: {
              case_sensitive: false
            }
  validates :barcode,
            presence: true,
            length: { maximum: 100 },
            uniqueness: true
  validates :name, presence: true, length: { maximum: 150 }
  validates :variant, presence: false, length: { maximum: 50 }
  validates :category_id, presence: true
  validates :brand_id, presence: true
end
