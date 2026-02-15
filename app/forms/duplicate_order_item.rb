class DuplicateOrderItem
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :order_number, :string
  attribute :tracking_number, :string

  attr_accessor :validation_context

  validates :order_number, :tracking_number, presence: true
  validate :validate_uniqueness

  private

  def validate_uniqueness
    return unless validation_context

    order_counter = validation_context[:order_counter] || {}
    tracking_counter = validation_context[:tracking_counter] || {}
    existing_order_numbers = validation_context[:existing_order_numbers] || []
    existing_tracking_numbers = validation_context[:existing_tracking_numbers] || []

    if order_number.present? && order_counter[order_number].to_i > 1
      errors.add(:order_number, 'duplicated in this form')
    end

    if tracking_number.present? && tracking_counter[tracking_number].to_i > 1
      errors.add(:tracking_number, 'duplicated in this form')
    end

    errors.add(:order_number, 'already exists') if existing_order_numbers.include?(order_number)

    return unless existing_tracking_numbers.include?(tracking_number)

    errors.add(:tracking_number, 'already exists')
  end
end
