# frozen_string_literal: true

class SuperAdmin::MerchantsController < SuperAdminApplicationController
  def index
    limit = RecordLimit.call(params[:limit])

    @q = Merchant.where(deleted_at: nil).ransack(params[:q])
    @merchants = @q.result.order(created_at: :desc)
    @pagy, @merchants = pagy(@merchants, limit:)
  end

  def new
    @merchant = Merchant.new
  end

  def create
    result = Merchants::Create.call(
      merchant_params: merchant_params
    )

    if result.success?
      redirect_to new_super_admin_merchant_path, notice: result.payload[:message]
    else
      @merchant = result.error[:merchant]

      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @merchant = merchant_scope
  end

  def update
    result = Merchants::Update.call(
      merchant: merchant_scope,
      merchant_params: merchant_params
    )

    if result.success?
      merchant = result.payload[:merchant]

      redirect_to edit_super_admin_merchant_path(merchant), notice: result.payload[:message]
    else
      @merchant = result.error[:merchant]

      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    result = Merchants::SoftDelete.call(
      merchant: merchant_scope
    )

    if result.success?
      redirect_to super_admin_merchants_path, notice: result.payload[:message]
    else
      redirect_to super_admin_merchants_path, alert: result.error[:merchant]
    end
  end

  def activate
    result = Merchants::Activate.call(
      merchant: merchant_scope
    )

    if result.success?
      redirect_to super_admin_merchants_path, notice: result.payload[:message]
    else
      redirect_to super_admin_merchants_path, alert: result.error[:merchant]
    end
  end

  def deactivate
    result = Merchants::Deactivate.call(
      merchant: merchant_scope
    )

    if result.success?
      redirect_to super_admin_merchants_path, notice: result.payload[:message]
    else
      redirect_to super_admin_merchants_path, alert: result.error[:merchant]
    end
  end

  private

  def merchant_params
    params.require(:merchant).permit(:name, :marketplace)
  end

  def merchant_scope
    Merchant.find(params[:id])
  end
end
