# frozen_string_literal: true

class CourierServices::Update < ApplicationService
  def call(courier_service:, courier_service_params:)
    courier_service.assign_attributes(courier_service_params)

    if courier_service.save
      success(
        courier_service: courier_service,
        message: "Courier service was successfully updated."
      )
    else
      failure(courier_service: courier_service)
    end
  end
end
