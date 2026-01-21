# frozen_string_literal: true

module RoleHelper
  def assign_roles_for_select
    Invitation::ROLES.map do |role|
      [ role.titleize, role ]
    end
  end

  def roles_for_select
     User.roles
      .except("super_admin")
      .map { |name, value| [ name.titleize, value ] }
  end
end
