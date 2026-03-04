# frozen_string_literal: true

module UserHelper
  def user_statuses_for_select
    user_statuses = [
      { name: 'Active', status: true },
      { name: 'Inactive', status: false }
    ]

    user_statuses.map do |user_status|
      [user_status[:name].titleize, user_status[:status]]
    end
  end

  def users_for_select
    User.where(is_active: true).order(username: :asc).map do |user|
      [user.username, user.id]
    end
  end

  def preparing_users_for_select
    User.where(role: %w[order_admin super_admin]).order(username: :asc).map do |user|
      [user.full_name[0..29], user.id]
    end
  end

  def delivered_users_for_select
    User.where(role: %w[dispatch_admin super_admin]).order(username: :asc).map do |user|
      [user.full_name[0..29], user.id]
    end
  end

  def paid_users_for_select
    User.where(role: %w[super_admin]).order(username: :asc).map do |user|
      [user.full_name[0..29], user.id]
    end
  end

  def cancelled_users_for_select
    User.where(role: %w[dispatch_admin super_admin]).order(username: :asc).map do |user|
      [user.full_name[0..29], user.id]
    end
  end
end
