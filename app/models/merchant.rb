# frozen_string_literal: true

class Merchant < ApplicationRecord
  # Relations
  has_many :order_batches

  # Ransack
  def self.ransackable_attributes(auth_object = nil)
    %w[id name marketplace is_active]
  end

  def self.ransackable_associations(auth_object = nil)
    []
  end

  # Normalization
  normalizes :name, with: ->(e) { e.to_s.strip.titleize }
  normalizes :marketplace, with: ->(e) { e.to_s.strip.titleize }

  # Validations
  validates :name, presence: true, length: { maximum: 100 }
  validates :marketplace, presence: true, length: { maximum: 50 }
end
