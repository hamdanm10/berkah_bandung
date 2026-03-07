# frozen_string_literal: true

class Users::Update < ApplicationService
  def call(user:, user_params:)
    user.assign_attributes(user_params)

    if user.save
      success(
        user: user,
        message: 'User was successfully updated.'
      )
    else
      failure(user: user)
    end
  end
end
