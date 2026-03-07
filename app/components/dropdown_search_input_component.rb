# frozen_string_literal: true

class DropdownSearchInputComponent < ViewComponent::Base
  attr_reader :form, :field_name, :search_url,
              :current_value, :current_label,
              :prompt, :wrapper_kwargs, :autofocus

  BASE_WRAPPER = 'relative w-full'
  BASE_INPUT   = 'block w-full p-2 text-gray-800 border border-gray-300 rounded-md bg-white text-sm'

  def initialize(
    form:,
    field_name:,
    search_url:,
    current_value: nil,
    current_label: nil,
    prompt: nil,
    autofocus: false,
    **wrapper_kwargs
  )
    @form = form
    @field_name = field_name
    @search_url = search_url
    @current_value = current_value
    @current_label = current_label
    @prompt = prompt
    @wrapper_kwargs = wrapper_kwargs
    @wrapper_kwargs[:class] = [BASE_WRAPPER, wrapper_kwargs[:class]].compact.join(' ')
    @autofocus = autofocus
  end

  def input_class
    BASE_INPUT
  end
end
