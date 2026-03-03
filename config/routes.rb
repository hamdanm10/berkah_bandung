Rails.application.routes.draw do
  root 'home#index'

  resource :session, only: %i[new create destroy]

  draw(:super_admin)
  draw(:order_supervisor)
  draw(:order_admin)

  # =====================
  # INVITATIONS
  # =====================
  resources :invitations, only: %i[new] do
    collection do
      post :verify
    end
  end

  # =====================
  # REGISTRATIONS
  # =====================
  resources :registrations, only: %i[new create]

  # =====================
  # SEARCH
  # =====================
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

  resources :brands, only: [] do
    collection do
      get :search
    end
  end

  resources :categories, only: [] do
    collection do
      get :search
    end
  end

  # get "up" => "rails/health#show", as: :rails_health_check
end
