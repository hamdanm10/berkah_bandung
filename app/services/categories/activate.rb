# frozen_string_literal: true

class Categories::Activate < ApplicationService
  def call(category:)
    return failure(message: "Category is already active.") if category.is_active?

    if category.update(is_active: true)
      success(
        category: category,
        message: "Category has been successfully activated."
      )
    else
      failure(category: category)
    end
  end
end
