# frozen_string_literal: true

class SuperAdmin::CourierServicesController < SuperAdminApplicationController
  def index
    limit = RecordLimit.call(params[:limit])

    @q = CourierService.where(deleted_at: nil).ransack(params[:q])
    @courier_services = @q.result.order(created_at: :desc)
    @pagy, @courier_services = pagy(@courier_services, limit:)
  end

  def new
    @courier_service = CourierService.new
  end

  def create
    result = CourierServices::Create.call(
      courier_service_params: courier_service_params
    )

    if result.success?
      redirect_to new_super_admin_courier_service_path, notice: result.payload[:message]
    else
      @courier_service = result.error[:courier_service]

      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @courier_service = courier_service_scope
  end

  def update
    result = CourierServices::Update.call(
      courier_service: courier_service_scope,
      courier_service_params: courier_service_params
    )

    if result.success?
      courier_service = result.payload[:courier_service]

      redirect_to edit_super_admin_courier_service_path(courier_service), notice: result.payload[:message]
    else
      @courier_service = result.error[:courier_service]

      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    result = CourierServices::SoftDelete.call(
      courier_service: courier_service_scope
    )

    if result.success?
      redirect_to super_admin_courier_services_path, notice: result.payload[:message]
    else
      redirect_to super_admin_courier_services_path, alert: result.error[:courier_service]
    end
  end

  def activate
    result = CourierServices::Activate.call(
      courier_service: courier_service_scope
    )

    if result.success?
      redirect_to super_admin_courier_services_path, notice: result.payload[:message]
    else
      redirect_to super_admin_courier_services_path, alert: result.error[:courier_service]
    end
  end

  def deactivate
    result = CourierServices::Deactivate.call(
      courier_service: courier_service_scope
    )

    if result.success?
      redirect_to super_admin_courier_services_path, notice: result.payload[:message]
    else
      redirect_to super_admin_courier_services_path, alert: result.error[:courier_service]
    end
  end

  def search
    q = params[:q].to_s.strip[0, 100]

    courier_services = CourierService
      .where(is_active: true, deleted_at: nil)
      .where("name ILIKE ?", "%#{q}%")
      .order(:name)
      .limit(15)

    render json: courier_services.map { |d|
      { value: d.id, label: d.name }
    }
  end

  private

  def courier_service_params
    params.require(:courier_service).permit(:name)
  end

  def courier_service_scope
    CourierService.find(params[:id])
  end
end
