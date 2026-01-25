# frozen_string_literal: true

class SuperAdmin::DistributorsController < SuperAdminApplicationController
  def index
    limit = RecordLimit.call(params[:limit])

    @q = Distributor.where(deleted_at: nil).ransack(params[:q])
    @distributors = @q.result.order(created_at: :desc)
    @pagy, @distributors = pagy(@distributors, limit:)
  end

  def new
    @distributor = Distributor.new
  end

  def create
    result = Distributors::Create.call(
      distributor_params: distributor_params
    )

    if result.success?
      redirect_to new_super_admin_distributor_path, notice: result.payload[:message]
    else
      @distributor = result.error[:distributor]

      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @distributor = distributor_scope
  end

  def update
    result = Distributors::Update.call(
      distributor: distributor_scope,
      distributor_params: distributor_params
    )

    if result.success?
      distributor = result.payload[:distributor]

      redirect_to edit_super_admin_distributor_path(distributor), notice: result.payload[:message]
    else
      @distributor = result.error[:distributor]

      render :edit, status: :unprocessable_entity
    end
  end

  def update
    result = Distributors::Update.call(
      distributor: distributor_scope,
      distributor_params: distributor_params
    )

    if result.success?
      distributor = result.payload[:distributor]

      redirect_to edit_super_admin_distributor_path(distributor), notice: result.payload[:message]
    else
      @distributor = result.error[:distributor]

      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    result = Distributors::SoftDelete.call(
      distributor: distributor_scope
    )

    if result.success?
      redirect_to super_admin_distributors_path, notice: result.payload[:message]
    else
      redirect_to super_admin_distributors_path, alert: result.error[:distributor]
    end
  end

  def activate
    result = Distributors::Activate.call(
      distributor: distributor_scope
    )

    if result.success?
      redirect_to super_admin_distributors_path, notice: result.payload[:message]
    else
      redirect_to super_admin_distributors_path, alert: result.error[:distributor]
    end
  end

  def deactivate
    result = Distributors::Deactivate.call(
      distributor: distributor_scope
    )

    if result.success?
      redirect_to super_admin_distributors_path, notice: result.payload[:message]
    else
      redirect_to super_admin_distributors_path, alert: result.error[:distributor]
    end
  end

  def search
    q = params[:q].to_s.strip[0, 100]

    distributors = Distributor
      .where(is_active: true, deleted_at: nil)
      .where("name ILIKE ?", "%#{q}%")
      .order(:name)
      .limit(15)

    render json: distributors.map { |d|
      { value: d.id, label: d.name }
    }
  end

  private

  def distributor_params
    params.require(:distributor).permit(:name)
  end

  def distributor_scope
    Distributor.find(params[:id])
  end
end
