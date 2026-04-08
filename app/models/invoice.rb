# frozen_string_literal: true

class Invoice < ApplicationRecord
  enum :invoice_type, {
    normal: 0,
    return: 1
  }

  belongs_to :distributor
  belongs_to :user_created, foreign_key: :created_by_user_id, class_name: 'User'

  has_many :invoice_items, dependent: :destroy
  accepts_nested_attributes_for :invoice_items, allow_destroy: true

  validates :invoice_type, presence: true
  validates :invoice_number, presence: true
  validates :invoice, presence: true, length: { maximum: 50 }
  validates :distributor_id, presence: true
  validates :invoice_amount,
            allow_nil: true,
            numericality: {
              greater_than_or_equal_to: 0,
              less_than_or_equal_to: 9_999_000_000_000
            }
  validates :entered_amount,
            presence: true,
            numericality: {
              greater_than_or_equal_to: 0,
              less_than_or_equal_to: 9_999_000_000_000
            }
  validates :transfer_amount,
            allow_nil: true,
            numericality: {
              greater_than_or_equal_to: 0,
              less_than_or_equal_to: 9_999_000_000_000
            }
  validates :total_transfer_amount,
            allow_nil: true,
            numericality: {
              greater_than_or_equal_to: 0,
              less_than_or_equal_to: 9_999_000_000_000
            }

  def self.ransackable_attributes(_auth_object = nil)
    %w[invoice_status invoice_type invoice_number invoice distributor_id created_at]
  end

  def self.ransackable_associations(_auth_object = nil)
    %w[distributor user_created]
  end
end
