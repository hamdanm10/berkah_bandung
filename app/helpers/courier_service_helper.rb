# frozen_string_literal: true

module CourierServiceHelper
  def courier_service_statuses_for_select
    courier_service_statuses = [
      { name: 'Active', status: true },
      { name: 'Inactive', status: false }
    ]

    courier_service_statuses.map do |courier_service_status|
      [courier_service_status[:name].titleize, courier_service_status[:status]]
    end
  end

  def courier_services_for_select
    CourierService.where(is_active: true, deleted_at: nil).order(name: :asc).map do |courier_service|
      [courier_service.name, courier_service.id]
    end
  end
end
