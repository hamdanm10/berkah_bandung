# frozen_string_literal: true

class OrderAdminApplicationController < ApplicationController
  before_action :authenticate_order_admin!

  layout 'order_admin/application'

  private

  def authenticate_order_admin!
    return if Current.user&.order_admin?

    head :forbidden
  end
end
