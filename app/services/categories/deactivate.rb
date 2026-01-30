# frozen_string_literal: true

class Categories::Deactivate < ApplicationService
  def call(category:)
    return failure(message: "Category is already inactive.") unless category.is_active?

    if category.update(is_active: false)
      success(
        category: category,
        message: "Category has been successfully deactivated."
      )
    else
      failure(category: category)
    end
  end
end
