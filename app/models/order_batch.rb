# frozen_string_literal: true

class OrderBatch < ApplicationRecord
  # Relations
  belongs_to :merchant

  # Ransack
  def self.ransackable_attributes(auth_object = nil)
    [ "code", "created_at" ]
  end

  def self.ransackable_associations(auth_object = nil)
    []
  end

  # Validations
  validates :code, presence: true
end
