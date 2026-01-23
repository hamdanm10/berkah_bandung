# frozen_string_literal: true

class CourierServices::Create < ApplicationService
  def call(courier_service_params:)
    courier_service = CourierService.new(
      courier_service_params.merge(
        is_active: true
      )
    )

    if courier_service.save
      success(
        courier_service: courier_service,
        message: "Courier service was successfully created."
      )
    else
      failure(courier_service: courier_service)
    end
  end
end
