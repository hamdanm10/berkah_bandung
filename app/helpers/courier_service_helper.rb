# frozen_string_literal: true

module CourierServiceHelper
  def courier_service_statuses_for_select
    courier_service_statuses = [
      { name: "Active", status: true },
      { name: "Inactive", status: false }
    ]

    courier_service_statuses.map do |courier_service_status|
      [ courier_service_status[:name].titleize, courier_service_status[:status] ]
    end
  end
end
