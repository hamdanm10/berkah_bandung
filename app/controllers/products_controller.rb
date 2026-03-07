# frozen_string_literal: true

class ProductsController < ApplicationController
  allow_unauthenticated_access

  def search
    q = params[:q].to_s.strip[0, 100]

    products = Product
               .where(is_active: true, deleted_at: nil)
               .where('code ILIKE :q OR name ILIKE :q', q: "%#{q}%")
               .order(:name)
               .limit(15)

    render json: products.map { |d|
      { value: d.id, label: "#{d.code} | #{d.name}" }
    }
  end
end
