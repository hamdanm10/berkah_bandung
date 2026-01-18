# frozen_string_literal: true

class PaginationComponent < ViewComponent::Base
  include Pagy::Frontend
  include ::PaginationHelper

  attr_reader :records, :pagy

  def initialize(records:, pagy:)
    @records = records
    @pagy = pagy
  end
end
