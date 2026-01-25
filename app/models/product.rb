# frozen_string_literal: true

class Product < ApplicationRecord
  # Relations
  belongs_to :category
  belongs_to :brand
  belongs_to :distributor

  has_many :product_prices, dependent: :destroy
  accepts_nested_attributes_for :product_prices, allow_destroy: true

  # Ransack
  def self.ransackable_attributes(auth_object = nil)
    [ "name", "is_active" ]
  end

  def self.ransackable_associations(auth_object = nil)
    []
  end

  # Normalization
  normalizes :code, with: ->(e) { e.to_s.strip.upcase }

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
  validates :distributor_id, presence: true

  # Custom Validations
  validate :must_have_at_least_one_price

  private

  def must_have_at_least_one_price
    valid_prices = product_prices.reject(&:marked_for_destruction?)
    errors.add(:base, "Product must have at least one price") if valid_prices.empty?
  end
end
