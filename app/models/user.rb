class User < ApplicationRecord
  has_secure_password

  enum :user_type, { super_admin: 0, order_supervisor: 1, order_admin: 2, inventory_admin: 3, returns_admin: 4 }, default: :order_admin

  has_many :sessions, dependent: :destroy

  normalizes :username, with: ->(e) { e.strip.downcase }
end
