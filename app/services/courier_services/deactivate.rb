# frozen_string_literal: true

class CourierServices::Deactivate < ApplicationService
  def call(courier_service:)
    return failure(message: "Courier service is already inactive.") unless courier_service.is_active?

    if courier_service.update(is_active: false)
      success(
        courier_service: courier_service,
        message: "Courier service has been successfully deactivated."
      )
    else
      failure(courier_service: courier_service)
    end
  end
end
