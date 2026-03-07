# frozen_string_literal: true

module OrderHelper
  def order_statuses_for_select
    Order.statuses.map do |status|
      [status[0].titleize, status[1]]
    end
  end
end
