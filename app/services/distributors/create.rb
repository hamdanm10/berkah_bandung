# frozen_string_literal: true

class Distributors::Create < ApplicationService
  def call(distributor_params:)
    distributor = Distributor.new(
      distributor_params.merge(
        is_active: true
      )
    )

    if distributor.save
      success(
        distributor: distributor,
        message: 'Distributor was successfully created.'
      )
    else
      failure(distributor: distributor)
    end
  end
end
