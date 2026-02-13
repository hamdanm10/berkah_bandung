# frozen_string_literal: true

class Order < ApplicationRecord
  # ============================
  # Enums
  # ============================
  enum :status, {
    preparing: 0,
    delivered: 1,
    cancelled: 2,
    returned: 3,
    paid: 4
  }, default: :preparing

  # ============================
  # Relations
  # ============================
  belongs_to :paid_by, class_name: 'User', optional: true
  belongs_to :delivered_by, class_name: 'User', optional: true
  belongs_to :cancelled_by, class_name: 'User', optional: true
  belongs_to :returned_by,  class_name: 'User', optional: true

  belongs_to :order_batch
  belongs_to :courier_service

  has_many :order_items
  accepts_nested_attributes_for :order_items, allow_destroy: true

  # ============================
  # Scopes
  # ============================
  scope :with_total_items, lambda {
    joins(<<~SQL)
      LEFT JOIN (
        SELECT
          order_id,
          COUNT(*) AS total_items
        FROM order_items
        GROUP BY order_id
      ) order_items_count
      ON order_items_count.order_id = orders.id
    SQL
      .select('orders.*, COALESCE(order_items_count.total_items, 0) AS total_items')
  }

  # ============================
  # Ransack
  # ============================
  def self.ransackable_attributes(auth_object = nil)
    %w[order_number tracking_number courier_service_id created_at]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[
      order_batch
      order_batch_user_created
      order_batch_merchant
    ]
  end

  # ============================
  # Validations
  # ============================
  validates :order_number, presence: true
  validates :tracking_number, presence: true
  validates :courier_service_id, presence: true
end
