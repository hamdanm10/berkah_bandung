class SuperAdminApplicationController < ApplicationController
  before_action :authenticate_super_admin!

  layout "super_admin/application"

  private

  def authenticate_super_admin!
    return if Current.user&.super_admin?
    head :forbidden
  end
end
