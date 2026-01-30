# frozen_string_literal: true

class Distributors::Update < ApplicationService
  def call(distributor:, distributor_params:)
    distributor.assign_attributes(distributor_params)

    if distributor.save
      success(
        distributor: distributor,
        message: "Distributor was successfully updated."
      )
    else
      failure(distributor: distributor)
    end
  end
end
