# frozen_string_literal: true

class Order < ApplicationRecord
  # Relations
  belongs_to :order_batch
  belongs_to :courier_service

  # Ransack
  def self.ransackable_attributes(auth_object = nil)
    []
  end

  def self.ransackable_associations(auth_object = nil)
    []
  end

  # Validations
end
