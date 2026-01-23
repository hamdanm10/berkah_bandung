# frozen_string_literal: true

class CourierServices::SoftDelete < ApplicationService
  def call(courier_service:)
    return failure(message: "Courier service is already deleted.") if courier_service.deleted_at.present?

    if courier_service.update(
      deleted_at: Time.current,
      is_active: false
    )
      success(
        courier_service: courier_service,
        message: "Courier service has been successfully deleted."
      )
    else
      failure(courier_service: courier_service)
    end
  end
end
