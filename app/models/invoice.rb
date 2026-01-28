# frozen_string_literal: true

class Invoice < ApplicationRecord
    # Transaction lifecycle status
    enum :invoice_status, {
      draft: 0,
      posted: 1,
      paid: 2
    }

    # Transaction type
    enum :invoice_type, {
      normal: 0,
      return: 1,
      adjustment: 2
    }

  # Relations
  belongs_to :distributor

  belongs_to :reference_invoice,
             class_name: "Invoice",
             foreign_key: :reference_invoice_id,
             optional: true

  has_one :referenced_invoice,
          class_name: "Invoice",
          foreign_key: :reference_invoice_id,
          dependent: :nullify

  # Ransack
  def self.ransackable_attributes(auth_object = nil)
    []
  end

  def self.ransackable_associations(auth_object = nil)
    []
  end

  # Validations
  validates :distributor_id, presence: true
  validates :invoice, presence: true, length: { maximum: 50 }
  validates :entered_amount, presence: true, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 9_999_000_000_000 }
  validates :invoice_amount, allow_nil: true, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 9_999_000_000_000 }
  validates :invoice_number, presence: true
  validates :received_date, presence: false
  validates :transfer_amount, allow_nil: true, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 9_999_000_000_000 }
  validates :total_transfer_amount, allow_nil: true, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 9_999_000_000_000 }
  validates :transfer_date, presence: false
  validates :remarks, presence: false
  validates :invoice_type, presence: true
  validates :reference_invoice_id,
            uniqueness: true,
            allow_nil: true
end
