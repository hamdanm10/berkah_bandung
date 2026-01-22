# frozen_string_literal: true

class ButtonToComponent < ViewComponent::Base
  attr_reader :url, :method, :kwargs

  BASE_CLASS = "flex justify-center gap-2 items-center font-medium rounded-md cursor-pointer transition-all duration-300"

  def initialize(size: "md", variant: "primary", url:, method:, **kwargs)
    @size = size
    @variant = variant
    @url = url
    @method = method
    @kwargs = kwargs

    @kwargs[:class] = [
      BASE_CLASS,
      size_classes,
      variant_classes,
      kwargs[:class]
    ].compact.join(" ")
  end

  private

  def size_classes
    case @size
    when "xs"
      "px-3 py-2 text-xs"
    when "sm"
      "px-3 py-2 text-sm"
    when "md"
      "px-5 py-2.5 text-sm"
    when "lg"
      "px-5 py-3 text-base"
    when "xl"
      "px-6 py-3.5 text-base"
    end
  end

  def variant_classes
    case @variant
    when "primary"
      "text-white bg-primary hover:bg-primary-hover"
    when "secondary"
      "text-white bg-secondary hover:bg-secondary-hover"
    when "dark"
      "text-white bg-dark hover:bg-dark-hover"
    when "light"
      "text-dark bg-light hover:bg-light-hover border border-gray-300"
    when "success"
      "text-white bg-success hover:bg-success-hover"
    when "danger"
      "text-white bg-danger hover:bg-danger-hover"
    when "warning"
      "text-white bg-warning hover:bg-warning-hover"
    when "info"
      "text-white bg-info hover:bg-info-hover"
    end
  end
end
