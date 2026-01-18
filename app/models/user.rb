# frozen_string_literal: true

class User < ApplicationRecord
  has_secure_password

  enum :user_type, { super_admin: 0, order_supervisor: 1, order_admin: 2, inventory_admin: 3, returns_admin: 4 }, default: :order_admin

  # Relations
  has_many :sessions, dependent: :destroy
  has_one :invitation, foreign_key: :used_by_user_id

  normalizes :username, with: ->(e) { e.strip.downcase }
end
