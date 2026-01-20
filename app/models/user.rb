# frozen_string_literal: true

class User < ApplicationRecord
  has_secure_password

  enum :user_type, {
    super_admin: 0,
    order_supervisor: 1,
    order_admin: 2,
    inventory_admin: 3,
    returns_admin: 4
  }, default: :order_admin

  # Relations
  has_many :sessions, dependent: :destroy
  has_one :invitation, foreign_key: :used_by_user_id

  # Normalization
  normalizes :username, with: ->(e) { e.to_s.strip.downcase }

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
