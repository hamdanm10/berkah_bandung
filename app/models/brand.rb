# frozen_string_literal: true

class Brand < ApplicationRecord
  # Relations
  has_many :products

  # Ransack
  def self.ransackable_attributes(auth_object = nil)
    [ "name", "is_active" ]
  end

  def self.ransackable_associations(auth_object = nil)
    []
  end

  # Normalization
  normalizes :name, with: ->(e) { e.to_s.strip.titleize }

  # Validations
  validates :name,
    presence: true,
    length: { maximum: 100 },
    uniqueness: {
      case_sensitive: false
    }
end
