# frozen_string_literal: true

class Products::Import < ApplicationService
  REQUIRED_HEADERS = [
    "Code", "Barcode", "Product Name",
    "Variant", "Category", "Brand",
    "Cost Price", "Quantity"
  ].freeze

  STRING_FIELDS = [
    "Code", "Barcode", "Product Name",
    "Variant", "Category", "Brand"
  ].freeze

  INTEGER_FIELDS = [ "Quantity" ].freeze
  DECIMAL_FIELDS = [ "Cost Price" ].freeze

  def call(product_import_params:)
    form = ProductImportForm.new(product_import_params)
    return failure(product_import: form) unless form.valid?

    errors = import_products(form.file)

    return failure(
      product_import: form,
      import_errors: errors
    ) if errors.any?

    success(message: "Products imported successfully.")
  end

  private

  def import_products(file)
    sheet   = Roo::Spreadsheet.open(file.path).sheet(0)
    headers = sheet.row(1).map { |h| h.to_s.strip }
    errors  = []

    missing = REQUIRED_HEADERS - headers
    if missing.any?
      return [ {
        row: 1,
        message: "Missing headers: #{missing.join(', ')}"
      } ]
    end

    ActiveRecord::Base.transaction do
      sheet.each_row_streaming(offset: 1).with_index(2) do |row, row_number|
        raw_row  = headers.zip(row.map(&:value)).to_h
        row_data = cast_row(raw_row)

        begin
          process_row(row_data, row_number, errors)
        rescue => e
          Rails.logger.error(e.full_message)
          errors << { row: row_number, message: "Unexpected error" }
        end
      end

      raise ActiveRecord::Rollback if errors.any?
    end

    errors
  end

  def cast_row(row)
    casted = {}

    STRING_FIELDS.each do |key|
      value = row[key]
      casted[key] =
        value.is_a?(Numeric) ? value.to_i.to_s : value.to_s.strip
    end

    INTEGER_FIELDS.each do |key|
      casted[key] = to_integer(row[key])
    end

    DECIMAL_FIELDS.each do |key|
      casted[key] = to_decimal(row[key])
    end

    casted
  end

  def process_row(row, row_number, errors)
    code       = row["Code"]
    barcode    = row["Barcode"]
    cost_price = row["Cost Price"]
    quantity   = row["Quantity"]

    return error(errors, row_number, "Invalid cost price") if cost_price.nil? || cost_price <= 0
    return error(errors, row_number, "Quantity must be an integer") if quantity.nil?

    category_name = row["Category"].titleize
    brand_name    = row["Brand"].titleize

    category = Category.find_by(name: category_name)
    brand    = Brand.find_by(name: brand_name)

    return error(errors, row_number, "Category '#{row['Category']}' not found") unless category
    return error(errors, row_number, "Brand '#{row['Brand']}' not found") unless brand

    product_by_code    = Product.find_by(code: code)
    product_by_barcode = Product.find_by(barcode: barcode)

    if product_by_code && product_by_code.barcode != barcode
      return error(errors, row_number, "Barcode duplicate for code '#{code}'")
    end

    if product_by_barcode && product_by_barcode.code != code
      return error(errors, row_number, "Code duplicate for barcode '#{barcode}'")
    end

    product = product_by_code || product_by_barcode

    unless product
      product = Product.create!(
        code: code,
        barcode: barcode,
        name: row["Product Name"],
        variant: row["Variant"],
        category: category,
        brand: brand
      )
    end

    if ProductPrice.exists?(product: product, cost_price: cost_price)
      return error(errors, row_number, "Product price already exists")
    end

    ProductPrice.create!(
      product: product,
      cost_price: cost_price,
      quantity: quantity
    )
  end

  def to_integer(value)
    return nil if value.blank?

    if value.is_a?(Numeric)
      value.to_i
    else
      str = value.to_s.strip
      return nil unless str.match?(/\A-?\d+\z/)
      str.to_i
    end
  end

  def to_decimal(value)
    return nil if value.blank?
    value.is_a?(Numeric) ? value.to_d : value.to_s.gsub(",", "").to_d
  end

  def error(errors, row, message)
    errors << { row: row, message: message }
    nil
  end
end
