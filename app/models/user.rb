# frozen_string_literal: true

class User < ApplicationRecord
  has_secure_password

  enum :role, {
    super_admin: 0,
    order_supervisor: 1,
    order_admin: 2,
    inventory_admin: 3,
    returns_admin: 4
  }, default: :order_admin

  # Relations
  has_many :sessions, dependent: :destroy
  has_one :invitation, foreign_key: :used_by_user_id
  has_many :invoices, foreign_key: :created_by_user_id
  has_many :order_batches, foreign_key: :created_by_user_id

  # Ransack
  def self.ransackable_attributes(auth_object = nil)
    [ "role", "username", "full_name", "is_active" ]
  end

  def self.ransackable_associations(auth_object = nil)
    []
  end


  # Normalization
  normalizes :username, with: ->(e) { e.to_s.strip.downcase }
  normalizes :full_name, with: ->(e) { e.to_s.strip.titleize }

  # Constants
  VALID_USERNAME_REGEX = /\A[a-z0-9_]+\z/

  # Validations
  validates :full_name, presence: true, length: { maximum: 100 }

  validates :username,
            presence: true,
            uniqueness: { case_sensitive: false },
            length: { minimum: 4, maximum: 20 },
            format: {
              with: VALID_USERNAME_REGEX,
              message: "only allows lowercase letters, numbers, and underscores"
            }

  validates :password,
            length: { minimum: 8 },
            if: -> { password.present? }
end
