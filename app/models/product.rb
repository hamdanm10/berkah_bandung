# frozen_string_literal: true

class Product < ApplicationRecord
  # Relations
  belongs_to :category
  belongs_to :brand

  has_many :distributor_items
  has_many :order_items
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
    left_joins(:product_availables)
      .select('products.*, COALESCE(SUM(product_availables.quantity), 0) AS total_quantity')
      .group('products.id')
  }

  # Validations
  validates :code,
            presence: true,
            length: { maximum: 20 },
            format: {
              with: /\A[^\s]+\z/,
              message: 'cannot contain spaces'
            },
            uniqueness: true
  validates :barcode,
            presence: true,
            length: { maximum: 100 },
            uniqueness: true
  validates :name, presence: true, length: { maximum: 150 }
  validates :category_id, presence: true
  validates :brand_id, presence: true
end
