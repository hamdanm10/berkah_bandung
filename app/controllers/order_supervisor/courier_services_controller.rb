# frozen_string_literal: true

class OrderSupervisor::CourierServicesController < OrderSupervisorApplicationController
  def index
    limit = RecordLimit.call(params[:limit])

    @q = CourierService.where(deleted_at: nil).ransack(params[:q])
    @courier_services = @q.result.order(created_at: :desc)
    @pagy, @courier_services = pagy(@courier_services, limit:)
  end
end
