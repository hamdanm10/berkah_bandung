# frozen_string_literal: true

class FilterComponent < ViewComponent::Base
  include Ransack::Helpers::FormHelper

  def initialize(q:, url:, method: :get, mode: :auto, fields:)
    @q = q
    @url = url
    @method = method
    @mode = mode
    @fields = normalize_fields(fields)
  end

  def form_data
    return {} unless auto_submit_form?

    { controller: "auto-submit" }
  end

  def show_submit_button?
    @fields.any? { |f| f[:manual] }
  end

  def field_data(field)
    return {} unless field[:auto_submit]

    { action: "change->auto-submit#submit" }
  end

  def auto_submit_form?
    @mode == :auto
  end

  def normalize_fields(fields)
    fields.map do |field|
      auto = auto_submit_form? && field.fetch(:auto_submit, false)

      field.merge(
        auto_submit: auto,
        manual: !auto
      )
    end
  end

  def render_field(form, field)
    common_kwargs = {
      data: field_data(field)
    }

    case field[:type]
    when :search
      helpers.render Ui::TextInputComponent.new(
        form: form,
        field_name: field[:name],
        placeholder: field[:placeholder],
        **common_kwargs
      )

    when :select
      helpers.render Ui::SelectInputComponent.new(
        form: form,
        field_name: field[:name],
        records: field[:records],
        current_value: @q&.send(field[:name]),
        include_blank: field[:blank],
        **common_kwargs
      )

    else
      raise ArgumentError, "Unknown filter field type: #{field[:type]}"
    end
  end
end
