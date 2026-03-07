# frozen_string_literal: true

class ScanOrderForm
  include ActiveModel::Model

  attr_accessor :order_number

  validates :order_number, presence: true
  validate :order_must_exist

  private

  def order_must_exist
    return if order_number.blank?

    return if Order.exists?(order_number: order_number)

    errors.add(:order_number, 'not found')
  end
end
