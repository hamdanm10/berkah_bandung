# frozen_string_literal: true

class Users::Deactivate < ApplicationService
  def call(user:)
    return failure(message: "User is already inactive.") unless user.is_active?

    if user.update(is_active: false)
      success(
        user: user,
        message: "User has been successfully deactivated."
      )
    else
      failure(user: user)
    end
  end
end
