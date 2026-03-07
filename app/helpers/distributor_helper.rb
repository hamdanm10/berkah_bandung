# frozen_string_literal: true

module DistributorHelper
  def distributor_statuses_for_select
    distributor_statuses = [
      { name: 'Active', status: true },
      { name: 'Inactive', status: false }
    ]

    distributor_statuses.map do |distributor_status|
      [distributor_status[:name].titleize, distributor_status[:status]]
    end
  end

  def distributors_for_select
    Distributor.where(is_active: true, deleted_at: nil).order(name: :asc).map do |distributor|
      [distributor.name, distributor.id]
    end
  end
end
