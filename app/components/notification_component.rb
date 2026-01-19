# frozen_string_literal: true

class NotificationComponent < ViewComponent::Base
  include LucideRails::RailsHelper

  attr_reader :message

  def initialize(message:)
    @message = message
  end

  def render?
    flash[:notice]
  end
end
