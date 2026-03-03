# frozen_string_literal: true

class OrderItem < ApplicationRecord
  # ============================
  # Relations
  # ============================
  belongs_to :order
  belongs_to :product

  has_many :order_item_filled_details

  # ============================
  # Callbacks
  # ============================
  before_validation :snapshot_product_data, on: :create
  before_validation :resnapshot_product_data, on: :update

  # ============================
  # Validations
  # ============================
  validates :product_id, presence: true
  validates :quantity, presence: true, numericality: { greater_than: 0 }
  validates :variant, presence: false, length: { maximum: 50 }

  validates :product_code, presence: true
  validates :product_name, presence: true

  # ============================
  # Ransack
  # ============================
  def self.ransackable_attributes(_auth_object = nil)
    []
  end

  def self.ransackable_associations(_auth_object = nil)
    []
  end

  private

  def snapshot_product_data
    return unless product

    self.product_code    ||= product.code
    self.product_name    ||= product.name
  end

  def resnapshot_product_data
    return unless will_save_change_to_product_id?
    return unless product

    self.product_code    = product.code
    self.product_name    = product.name
  end
end
