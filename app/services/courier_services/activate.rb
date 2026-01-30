# frozen_string_literal: true

class CourierServices::Activate < ApplicationService
  def call(courier_service:)
    return failure(message: "Courier service is already active.") if courier_service.is_active?

    if courier_service.update(is_active: true)
      success(
        courier_service: courier_service,
        message: "Courier service has been successfully activated."
      )
    else
      failure(courier_service: courier_service)
    end
  end
end
