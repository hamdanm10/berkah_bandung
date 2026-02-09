# app/forms/duplicate_order_item.rb
class DuplicateOrderItem
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :order_number, :string
  attribute :tracking_number, :string

  validates :order_number, :tracking_number, presence: true
end
