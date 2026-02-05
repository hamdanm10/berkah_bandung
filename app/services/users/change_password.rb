# frozen_string_literal: true

class Users::ChangePassword < ApplicationService
  def call(user:, password_params:)
    user.assign_attributes(password_params)

    if user.save
      success(
        user: user,
        message: 'Password was successfully changed.'
      )
    else
      failure(user: user)
    end
  end
end
