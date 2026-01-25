# frozen_string_literal: true

class NumberInputComponent < ViewComponent::Base
  attr_reader :form, :field_name, :kwargs

  BASE_CLASS = "block w-full p-2 text-gray-700 border border-gray-300 rounded-md bg-white text-sm"

  def initialize(form:, field_name:, **kwargs)
    @form = form
    @field_name = field_name
    @kwargs = kwargs

    @kwargs[:class] = [
      BASE_CLASS,
      kwargs[:class]
    ].compact.join(" ")
  end
end
