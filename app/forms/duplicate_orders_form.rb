class DuplicateOrdersForm
  include ActiveModel::Model
  include ActiveModel::Attributes

  MAX_DUPLICATE = 100

  attribute :product_id, :integer
  attribute :variant, :string
  attribute :quantity, :integer
  attribute :courier_service_id, :integer
  attribute :duplicate_count, :integer

  attr_accessor :orders, :product_label, :courier_label

  validates :product_id, :quantity, :courier_service_id, presence: true
  validates :variant, length: { maximum: 50 }, allow_blank: true
  validates :duplicate_count,
            presence: true,
            numericality: {
              greater_than: 0,
              less_than_or_equal_to: MAX_DUPLICATE
            },
            on: :generate

  validate :validate_orders, on: :create

  def initialize(attributes = {})
    super
    self.orders ||= []
  end

  # ==========================================
  # Build dynamic orders
  # ==========================================
  def build_orders
    count = duplicate_count.to_i

    if count <= 0
      self.orders = []
      return
    end

    self.orders = Array.new(count) do |i|
      orders[i] || DuplicateOrderItem.new
    end
  end

  # ==========================================
  # MAIN VALIDATION
  # ==========================================
  private

  def validate_orders
    build_orders

    # ===============================
    # Collect values
    # ===============================
    order_numbers = orders.map(&:order_number).compact
    tracking_numbers = orders.map(&:tracking_number).compact

    # ===============================
    # O(n) batch counter
    # ===============================
    order_counter = order_numbers.tally
    tracking_counter = tracking_numbers.tally

    # ===============================
    # Database check (2 queries only)
    # ===============================
    existing_order_numbers =
      Order.where(order_number: order_numbers).pluck(:order_number)

    existing_tracking_numbers =
      Order.where(tracking_number: tracking_numbers).pluck(:tracking_number)

    # ===============================
    # Inject validation context
    # ===============================
    orders.each do |order_item|
      order_item.validation_context = {
        order_counter: order_counter,
        tracking_counter: tracking_counter,
        existing_order_numbers: existing_order_numbers,
        existing_tracking_numbers: existing_tracking_numbers
      }

      order_item.valid?
    end

    # ===============================
    # Merge child errors
    # ===============================
    orders.each_with_index do |order_item, index|
      order_item.errors.each do |attr, msg|
        errors.add("orders[#{index}].#{attr}", msg)
      end
    end
  end
end
