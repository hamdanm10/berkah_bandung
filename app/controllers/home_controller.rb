# frozen_string_literal: true

class HomeController < ApplicationController
  allow_unauthenticated_access

  layout "guest/application"

  def index
  end
end
