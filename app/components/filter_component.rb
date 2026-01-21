# frozen_string_literal: true

class FilterComponent < ViewComponent::Base
  include LucideRails::RailsHelper
  include Ransack::Helpers::FormHelper

  def initialize(q:, url:, method: :get, fields:, show_submit: false)
    @q = q
    @url = url
    @method = method
    @fields = fields
    @show_submit = show_submit
  end

  def form_data
    return {} unless auto_submit_form?

    { controller: "auto-submit" }
  end

  def show_submit_button?
    @show_submit
  end

  def field_data(field)
    return {} unless field[:auto_submit]

    { action: "change->auto-submit#submit" }
  end

  def auto_submit_form?
    @fields.any? { |f| f[:auto_submit] }
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
