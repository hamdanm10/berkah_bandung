# frozen_string_literal: true

module UserHelper
  def user_statuses_for_select
    user_statuses = [
      { name: "Active", status: true },
      { name: "Inactive", status: false }
    ]

    user_statuses.map do |user_status|
      [ user_status[:name].titleize, user_status[:status] ]
    end
  end
end
