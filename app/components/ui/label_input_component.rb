# frozen_string_literal: true

class Ui::LabelInputComponent < ViewComponent::Base
  attr_reader :form, :field_name, :label, :required, :kwargs

  BASE_CLASS = "text-gray-700 text-sm font-medium"

  def initialize(form:, field_name:, label: nil, required: false, **kwargs)
    @form = form
    @field_name = field_name
    @label = label
    @required = required
    @kwargs = kwargs

    @kwargs[:class] = [
      BASE_CLASS,
      kwargs[:class]
    ].compact.join(" ")
  end
end