# frozen_string_literal: true

class Distributors::Deactivate < ApplicationService
  def call(distributor:)
    return failure(message: "Distributor is already inactive.") unless distributor.is_active?

    if distributor.update(is_active: false)
      success(
        distributor: distributor,
        message: "Distributor has been successfully deactivated."
      )
    else
      failure(distributor: distributor)
    end
  end
end
