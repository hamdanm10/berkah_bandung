# frozen_string_literal: true

class Categories::Update < ApplicationService
  def call(category:, category_params:)
    category.assign_attributes(category_params)

    if category.save
      success(
        category: category,
        message: "Category was successfully updated."
      )
    else
      failure(category: category)
    end
  end
end
