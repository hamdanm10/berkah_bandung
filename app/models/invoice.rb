# frozen_string_literal: true

class Invoice < ApplicationRecord
  # ============================
  # Virtual Attributes
  # ============================
  attribute :copy_from_reference, :boolean, default: false

  # ============================
  # Enums
  # ============================
  enum :invoice_status, {
    draft: 0,
    posted: 1,
    paid: 2
  }

  enum :invoice_type, {
    normal: 0,
    return: 1,
    adjustment: 2
  }

  # ============================
  # Helpers
  # ============================
  def paid?
    invoice_status == "paid"
  end

  def posted?
    invoice_status == "posted"
  end

  def draft?
    invoice_status == "draft"
  end

  # ============================
  # Relations
  # ============================

  belongs_to :user_created, foreign_key: :created_by_user_id, class_name: "User"
  belongs_to :distributor

  belongs_to :reference_invoice,
             class_name: "Invoice",
             foreign_key: :reference_invoice_id,
             optional: true

  has_many :derived_invoices,
           class_name: "Invoice",
           foreign_key: :reference_invoice_id,
           dependent: :nullify

  has_many :invoice_items, dependent: :destroy
  accepts_nested_attributes_for :invoice_items, allow_destroy: true

  # ============================
  # Callbacks (ORDER MATTERS)
  # ============================
  before_validation :normalize_reference_fields
  before_validation :copy_reference_data, if: -> { copy_from_reference? && (return? || adjustment?) }

  before_update :guard_invoice_status_flow
  before_update :guard_update_by_status

  # ============================
  # Validations
  # ============================
  validate :must_have_at_least_one_invoice_item
  validate :reference_invoice_must_be_valid, if: -> { return? || adjustment? }

  validates :invoice_type, presence: true
  validates :invoice_status, presence: true
  validates :distributor_id, presence: true

  validates :invoice,
            presence: true,
            length: { maximum: 50 },
            unless: :copy_from_reference?

  validates :invoice_number,
            presence: true,
            unless: :copy_from_reference?

  validates :entered_amount,
            presence: true,
            numericality: {
              greater_than_or_equal_to: 0,
              less_than_or_equal_to: 9_999_000_000_000
            }

  validates :invoice_amount,
            allow_nil: true,
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

  validates :reference_invoice_id,
            presence: true,
            if: -> { return? || adjustment? }

  # ============================
  # Ransack
  # ============================
  def self.ransackable_attributes(_auth_object = nil)
    [ "invoice_status", "invoice_type", "invoice_number", "invoice", "distributor_id" ]
  end

  def self.ransackable_associations(_auth_object = nil)
    [ "distributor" ]
  end

  # ============================
  # Private
  # ============================
  private

  # ----------------------------
  # Reference helpers
  # ----------------------------
  def normalize_reference_fields
    return unless normal?

    self.reference_invoice_id = nil
    self.copy_from_reference  = false
  end

  def copy_reference_data
    return unless reference_invoice

    self.distributor_id        ||= reference_invoice.distributor_id
    self.invoice               = reference_invoice.invoice if invoice.blank?
    self.invoice_number        = reference_invoice.invoice_number if invoice_number.blank?
    self.entered_amount        ||= reference_invoice.entered_amount
    self.invoice_amount        ||= reference_invoice.invoice_amount
    self.received_date         ||= reference_invoice.received_date
    self.transfer_amount       ||= reference_invoice.transfer_amount
    self.total_transfer_amount ||= reference_invoice.total_transfer_amount
    self.transfer_date         ||= reference_invoice.transfer_date
    self.remarks               ||= reference_invoice.remarks
  end

  # ----------------------------
  # Business validations
  # ----------------------------
  def must_have_at_least_one_invoice_item
    valid_items = invoice_items.reject(&:marked_for_destruction?)
    return if valid_items.any?

    errors.add(:base, "Invoice must have at least 1 invoice item")
  end

  def reference_invoice_must_be_valid
    return if reference_invoice.blank?

    allowed_statuses = %w[posted paid]
    return if allowed_statuses.include?(reference_invoice.invoice_status)

    errors.add(
      :reference_invoice_id,
      "must reference an invoice with status Posted or Paid"
    )
  end

  # ============================
  # Status Flow Guard
  # ============================
  def guard_invoice_status_flow
    return unless saved_change_to_invoice_status?

    from, to = saved_change_to_invoice_status.map(&:to_s)

    allowed = {
      "draft"  => [ "posted" ],
      "posted" => [ "paid" ],
      "paid"   => []
    }

    unless allowed[from]&.include?(to)
      errors.add(
        :invoice_status,
        "invalid status transition from #{from} to #{to}"
      )
      throw :abort
    end
  end

  # ============================
  # Status-based Update Guard
  # ============================
  def guard_update_by_status
    return if draft?

    if paid?
      errors.add(:base, "Paid invoice cannot be modified")
      throw :abort
    end

    forbid_posted_changes! if posted?
  end

  def forbid_posted_changes!
    forbidden_attributes = %w[
      invoice_type
      reference_invoice_id
      copy_from_reference
    ]

    if forbidden_attributes.any? { |attr| saved_change_to_attribute?(attr) }
      errors.add(:base, "Posted invoice cannot change invoice type or reference")
      throw :abort
    end

    if invoice_items_changed?
      errors.add(:base, "Posted invoice cannot modify invoice items")
      throw :abort
    end
  end

  def invoice_items_changed?
    invoice_items.any? do |item|
      item.new_record? ||
        item.marked_for_destruction? ||
        item.changed?
    end
  end
end
