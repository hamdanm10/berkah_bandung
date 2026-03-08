# frozen_string_literal: true

class WarehouseAdminApplicationController < ApplicationController
  before_action :authenticate_warehouse_admin!

  layout 'warehouse_admin/application'

  private

  def authenticate_warehouse_admin!
    return if Current.user&.warehouse_admin?

    head :forbidden
  end
end
