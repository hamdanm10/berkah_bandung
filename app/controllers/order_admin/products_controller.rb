# frozen_string_literal: true

class OrderAdmin::ProductsController < OrderAdminApplicationController
  def index
    limit = RecordLimit.call(params[:limit])

    @q = Product
         .where(deleted_at: nil)
         .ransack(params[:q])

    @products = @q
                .result
                .with_total_quantity
                .includes(:category, :brand)
                .order(name: :asc)

    @pagy, @products = pagy(@products, limit:)
  end
end
