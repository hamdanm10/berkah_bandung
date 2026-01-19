# frozen_string_literal: true

class DropdownSearchInputComponent < ViewComponent::Base
  attr_reader :form,
              :field_name,
              :records,
              :current_value,
              :prompt,
              :wrapper_kwargs

  BASE_WRAPPER = "relative w-full"
  BASE_INPUT   = "block w-full p-2 text-gray-800 border border-gray-300 rounded-md bg-white text-sm"

  def initialize(
    form:,
    field_name:,
    records:,
    current_value: nil,
    prompt: nil,
    **wrapper_kwargs
  )
    @form = form
    @field_name = field_name
    @records = records
    @current_value = current_value
    @prompt = prompt

    @wrapper_kwargs = wrapper_kwargs
    @wrapper_kwargs[:class] = merge_classes(
      BASE_WRAPPER,
      wrapper_kwargs[:class]
    )
  end

  def input_class
    BASE_INPUT
  end

  def selected_label
    records.to_h.key(current_value)
  end

  def label_field_name
    :"#{field_name}_label"
  end

  private

  def merge_classes(*classes)
    classes.flatten.compact.join(" ")
  end
end
