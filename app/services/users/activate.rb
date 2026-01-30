# frozen_string_literal: true

class Users::Activate < ApplicationService
  def call(user:)
    return failure(message: "User is already active.") if user.is_active?

    if user.update(is_active: true)
      success(
        user: user,
        message: "User has been successfully activated."
      )
    else
      failure(user: user)
    end
  end
end
