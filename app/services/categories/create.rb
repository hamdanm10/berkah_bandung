# frozen_string_literal: true

class Categories::Create < ApplicationService
  def call(category_params:)
    category = Category.new(
      category_params.merge(
        is_active: true
      )
    )

    if category.save
      success(
        category: category,
        message: "Category was successfully created."
      )
    else
      failure(category: category)
    end
  end
end
