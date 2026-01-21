# frozen_string_literal: true

class Registrations::Create < ApplicationService
  def call(user_params:, invitation:)
    user = User.new(
      user_params.merge(
        role: invitation.assigned_role
      )
    )

    ActiveRecord::Base.transaction do
      user.save!

      invitation.update!(
        is_used: true,
        used_by_user_id: user.id,
        used_at: Time.current
      )
    end

    success(
      user: user,
      message: "User was successfully created."
    )
  rescue ActiveRecord::RecordInvalid => e
    failure(
      user: user,
      message: e.record.errors.full_messages.to_sentence
    )
  end
end
