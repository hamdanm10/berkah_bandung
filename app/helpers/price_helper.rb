# frozen_string_literal: true

module PriceHelper
  def format_price(price)
    number_to_currency(
      price,
      unit: "Rp. ",
      precision: 2,
      delimiter: ".",
      separator: ",",
      strip_insignificant_zeros: true
    )
  end
end
