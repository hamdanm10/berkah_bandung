# frozen_string_literal: true

class CourierService < ApplicationRecord
  # Ransack
  def self.ransackable_attributes(auth_object = nil)
    [ "name", "is_active" ]
  end

  def self.ransackable_associations(auth_object = nil)
    []
  end

  # Validations
  validates :name, presence: true, length: { maximum: 50 }
end
