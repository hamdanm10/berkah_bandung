Rails.application.routes.draw do
  root 'home#index'

  resource :session, only: %i[new create destroy]

  # Invitations
  resources :invitations, only: %i[new] do
    collection do
      post :verify
    end
  end

  # Register
  resources :registrations, only: %i[new create]

  resources :distributors, only: [] do
    collection do
      get :search
    end
  end

  resources :courier_services, only: [] do
    collection do
      get :search
    end
  end

  resources :products, only: [] do
    collection do
      get :search
    end
  end

  draw(:super_admin)
  draw(:order_supervisor)
  draw(:order_admin)

  # get "up" => "rails/health#show", as: :rails_health_check
end
