Rails.application.routes.draw do
  root "home#index"

  resource :session, only: %i[new create destroy]

  # Invitations
  resources :invitations, only: %i[new] do
    collection do
      post :verify
    end
  end

  # Register
  resources :registrations, only: %i[new create]

  draw(:super_admin)
  draw(:order_supervisor)

  # get "up" => "rails/health#show", as: :rails_health_check
end
