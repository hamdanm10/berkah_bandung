# frozen_string_literal: true

class DialogComponent < ViewComponent::Base
  include LucideRails::RailsHelper

  attr_reader :dialog_trigger, :dialog_header, :dialog_body, :dialog_footer

  def trigger(&block)
    @dialog_trigger = view_context.capture(&block)
  end

  def header(&block)
    @dialog_header = view_context.capture(&block)
  end

  def body(&block)
    @dialog_body = view_context.capture(&block)
  end

  def footer(&block)
    @dialog_footer = view_context.capture(&block)
  end

  private

  def before_render
    content
  end
end
