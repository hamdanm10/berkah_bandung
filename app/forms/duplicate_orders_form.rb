# app/forms/duplicate_orders_form.rb
class DuplicateOrdersForm
  include ActiveModel::Model
  include ActiveModel::Attributes

  # ======= Attributes utama =======
  attribute :product_id, :integer
  attribute :quantity, :integer
  attribute :courier_service_id, :integer
  attribute :duplicate_count, :integer

  # ======= Virtual attributes =======
  attr_accessor :orders # array of DuplicateOrderItem
  attr_accessor :product_label, :courier_label

  validates :product_id, :quantity, :courier_service_id, presence: true
  validates :duplicate_count,
            presence: true,
            numericality: { greater_than: 0 }

  validate :validate_orders

  def initialize(attributes = {})
    super
    self.orders ||= []
  end

  # ======= Build orders sesuai duplicate_count =======
  def build_orders
    count = duplicate_count.to_i

    # Jika 0 atau negatif → kosongkan orders
    if count <= 0
      self.orders = []
      return
    end

    self.orders = Array.new(count) do |i|
      orders[i] || DuplicateOrderItem.new
    end
  end

  private

  def validate_orders
    build_orders

    orders.each_with_index do |order_item, index|
      next unless order_item.is_a?(DuplicateOrderItem)

      order_item.valid? # triggers validation inside DuplicateOrderItem

      order_item.errors.each do |attr, msg|
        errors.add("orders[#{index}].#{attr}", msg)
      end
    end
  end
end
