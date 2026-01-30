# frozen_string_literal: true

module FormHelper
  def form_caption(resource_name, record)
    action_word = record&.persisted? ? "edit the" : "create a new"
    "Fill out the form below to #{action_word} #{resource_name}."
  end
end
