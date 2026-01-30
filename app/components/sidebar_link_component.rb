# frozen_string_literal: true

class SidebarLinkComponent < ViewComponent::Base
  include LucideRails::RailsHelper

  attr_reader :icon, :url, :name

  def initialize(icon:, url:, name: nil)
    @icon = icon
    @url = url
    @name = name
    @link_classes = link_classes
  end

  def before_render
    @active = is_active?
  end

  private

  def is_active?
    helpers.request.path.include?(url)
  end

  def link_classes
    case @active
    when true
      "text-primary bg-primary-soft"
    when false
      "text-secondary hover:bg-secondary-soft"
    end
  end
end
