# frozen_string_literal: true

class Distributors::Activate < ApplicationService
  def call(distributor:)
    return failure(message: "Distributor is already active.") if distributor.is_active?

    if distributor.update(is_active: true)
      success(
        distributor: distributor,
        message: "Distributor has been successfully activated."
      )
    else
      failure(distributor: distributor)
    end
  end
end
