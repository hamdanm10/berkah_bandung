# frozen_string_literal: true

class ReturnAdminApplicationController < ApplicationController
  before_action :authenticate_return_admin!

  layout 'return_admin/application'

  private

  def authenticate_return_admin!
    return if Current.user&.return_admin?

    head :forbidden
  end
end
