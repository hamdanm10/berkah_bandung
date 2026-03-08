# frozen_string_literal: true

class OrderAdmin::MerchantOrdersController < OrderAdminApplicationController
  def index
    limit = RecordLimit.call(params[:limit])

    @q = Merchant.where(is_active: true, deleted_at: nil).ransack(params[:q])
    @merchants = @q.result.order(created_at: :asc)
    @pagy, @merchants = pagy(@merchants, limit:)
  end
end
