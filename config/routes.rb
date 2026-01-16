Rails.application.routes.draw do
  root "home#index"

  resource :session

  draw(:super_admin)
  draw(:order_supervisor)

  # get "up" => "rails/health#show", as: :rails_health_check
end
