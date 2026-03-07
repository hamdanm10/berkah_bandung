# frozen_string_literal: true

class DistributorsController < ApplicationController
  allow_unauthenticated_access

  def search
    q = params[:q].to_s.strip[0, 100]

    distributors = Distributor
                   .where(is_active: true, deleted_at: nil)
                   .where('name ILIKE ?', "%#{q}%")
                   .order(:name)
                   .limit(15)

    render json: distributors.map { |d|
      { value: d.id, label: d.name }
    }
  end
end
