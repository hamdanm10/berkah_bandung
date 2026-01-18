# frozen_string_literal: true

class Invitation < ApplicationRecord
  ROLES = %w[order_supervisor order_admin inventory_admin returns_admin].freeze

  # Relations
  belongs_to :user, foreign_key: :used_by_user_id, class_name: "User", optional: true

  # Ransack
  def self.ransackable_attributes(auth_object = nil)
    [ "assigned_role", "created_at", "expires_at", "id", "invitation_code", "is_used", "updated_at", "used_at", "used_by_user_id" ]
  end

  # Validations
  validates :invitation_code, presence: true, length: { is: 6 }, uniqueness: true
  validates :assigned_role, inclusion: { in: ROLES }
  validates :expires_at, presence: true

  # Custom Validations
  validate :expires_at_cannot_be_in_the_past
  validate :used_fields_consistency

  # Scopes
  scope :active, -> {
    where(is_used: false)
      .where("expires_at > ?", Time.current)
  }

  # Helpers
  def expired?
    expires_at < Time.current
  end

  def usable?
    !is_used && !expired?
  end

  def status
    return :used if is_used
    return :expired if expired?
    :active
  end

  private

  def expires_at_cannot_be_in_the_past
    return if expires_at.blank?

    errors.add(:expires_at, "must be in the future") if expires_at <= Time.current
  end

  def used_fields_consistency
    return unless is_used

    errors.add(:used_by_user_id, "must be present") if used_by_user_id.blank?
    errors.add(:used_at, "must be present") if used_at.blank?
  end
end
