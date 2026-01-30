# frozen_string_literal: true

class ErrorInputComponent < ViewComponent::Base
  attr_reader :model, :field_name

  def initialize(model:, field_name:)
    @model = model
    @field_name = field_name
  end

  def render?
    @model.errors.include?(@field_name)
  end
end
