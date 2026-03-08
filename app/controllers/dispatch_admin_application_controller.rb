# frozen_string_literal: true

class DispatchAdminApplicationController < ApplicationController
  before_action :authenticate_dispatch_admin!

  layout 'dispatch_admin/application'

  private

  def authenticate_dispatch_admin!
    return if Current.user&.dispatch_admin?

    head :forbidden
  end
end
