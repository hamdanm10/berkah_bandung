# frozen_string_literal: true

class CheckboxInputComponent < ViewComponent::Base
  attr_reader :form, :field_name, :label, :kwargs

  def initialize(form:, field_name:, label: nil, **kwargs)
    @form = form
    @field_name = field_name
    @label = label
    @kwargs = kwargs
  end
end
