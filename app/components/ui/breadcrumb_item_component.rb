# frozen_string_literal: true

class Ui::BreadcrumbItemComponent < ViewComponent::Base
  include LucideRails::RailsHelper

  attr_reader :url, :icon, :name, :last

  def initialize(url: nil, icon: nil, name:, last: false)
    @url = url
    @icon = icon
    @name = name
    @last = last
  end
end
