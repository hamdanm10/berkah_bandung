# frozen_string_literal: true

class Product < ApplicationRecord
  # Relations
  belongs_to :category
  belongs_to :brand

  has_many :distributor_items
  has_many :order_items
  has_one :product_reserve
  has_many :product_availables

  # Ransack
  def self.ransackable_attributes(auth_object = nil)
    %w[code barcode name category_id brand_id is_active]
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
        FROM product_availables
        GROUP BY product_id
      ) product_availables_sum
        ON product_availables_sum.product_id = products.id
      LEFT JOIN product_reserves
        ON product_reserves.product_id = products.id
    SQL
      .select(<<~SQL)
        products.*,
        (
          COALESCE(product_availables_sum.total_quantity, 0)
          - COALESCE(product_reserves.quantity, 0)
        ) AS total_quantity
      SQL
  }

  # Validations
  validates :code,
            presence: true,
            length: { maximum: 20 },
            format: {
              with: /\A[^\s]+\z/,
              message: 'cannot contain spaces'
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
