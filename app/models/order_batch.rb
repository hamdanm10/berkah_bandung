# frozen_string_literal: true

class OrderBatch < ApplicationRecord
  # Relations
  belongs_to :merchant
  belongs_to :user_created, foreign_key: :created_by_user_id, class_name: 'User'
  has_many :orders

  # Ransack
  def self.ransackable_attributes(auth_object = nil)
    %w[code created_at]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[user_created merchant]
  end

  # Validations
  validates :code, presence: true
end
