# frozen_string_literal: true

class CourierService < ApplicationRecord
  # Relations
  has_many :orders

  # Ransack
  def self.ransackable_attributes(_auth_object = nil)
    %w[name is_active]
  end

  def self.ransackable_associations(_auth_object = nil)
    []
  end

  # Validations
  validates :name, presence: true, length: { maximum: 50 }
end
