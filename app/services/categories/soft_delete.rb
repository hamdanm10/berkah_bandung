# frozen_string_literal: true

class Categories::SoftDelete < ApplicationService
  def call(category:)
    return failure(message: "Category is already deleted.") if category.deleted_at.present?

    if category.update(
      deleted_at: Time.current,
      is_active: false
    )
      success(
        category: category,
        message: "Category has been successfully deleted."
      )
    else
      failure(category: category)
    end
  end
end
