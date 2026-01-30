# frozen_string_literal: true

class Distributors::SoftDelete < ApplicationService
  def call(distributor:)
    return failure(message: "Distributor is already deleted.") if distributor.deleted_at.present?

    if distributor.update(
      deleted_at: Time.current,
      is_active: false
    )
      success(
        distributor: distributor,
        message: "Distributor has been successfully deleted."
      )
    else
      failure(distributor: distributor)
    end
  end
end
