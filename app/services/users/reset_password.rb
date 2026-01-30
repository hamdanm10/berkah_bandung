# frozen_string_literal: true

class Users::ResetPassword < ApplicationService
  DEFAULT_PASSWORD = "BerkahBandung"

  def call(user:)
    if user.update(
      password: DEFAULT_PASSWORD,
      password_confirmation: DEFAULT_PASSWORD
    )
      success(
        user: user,
        message: "User password has been successfully reset."
      )
    else
      failure(user: user)
    end
  end
end
