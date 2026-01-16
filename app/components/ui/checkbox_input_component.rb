# frozen_string_literal: true

class Ui::CheckboxInputComponent < ViewComponent::Base
  attr_reader :form, :field_name, :label, :kwargs

  def initialize(form:, field_name:, label: nil)
    @form = form
    @field_name = field_name
    @label = label
  end
end