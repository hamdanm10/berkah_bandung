Rails.application.routes.draw do
  resource :session
  # get "up" => "rails/health#show", as: :rails_health_check

  draw(:super_admin)
  draw(:order_supervisor)
end
