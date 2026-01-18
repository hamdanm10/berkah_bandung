# frozen_string_literal: true

class RecordLimit < ApplicationService
  VALID_LIMITS = [ "10", "30", "50" ].freeze

  def call(limit_param)
    if VALID_LIMITS.include?(limit_param)
      limit_param.to_i
    else
      Pagy::DEFAULT[:items]
    end
  end
end
