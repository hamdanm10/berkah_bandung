# frozen_string_literal: true

module AssignedRoleHelper
  def assigned_roles_for_select
    assigned_roles = [
      "order_supervisor",
      "order_admin",
      "inventory_admin",
      "returns_admin"
    ]

    assigned_roles.map do |assigned_role|
      [ assigned_role.titleize, assigned_role ]
    end
  end
end
