# frozen_string_literal: true

class DistributorItem < ApplicationRecord
  # Relations
  belongs_to :distributor
  belongs_to :product
end
