class OrderSupervisorApplicationController < ApplicationController
  before_action :authenticate_order_supervisor!

  layout "order_supervisor/application"

  private

  def authenticate_order_supervisor!
    return if Current.user&.order_supervisor?
    head :forbidden
  end
end
