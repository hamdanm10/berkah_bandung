# frozen_string_literal: true

module CategoryHelper
  def category_statuses_for_select
    category_statuses = [
      { name: "Active", status: true },
      { name: "Inactive", status: false }
    ]

    category_statuses.map do |category_status|
      [ category_status[:name].titleize, category_status[:status] ]
    end
  end
end
