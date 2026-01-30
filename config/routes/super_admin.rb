namespace :super_admin do
  resource :dashboard, only: %i[show]

  resources :invitations, except: %i[destroy]

  resources :users, only: %i[index show] do
    member do
      patch :activate
      patch :deactivate
      patch :reset_password
    end
  end

  resources :merchants, except: %i[show] do
    member do
      patch :activate
      patch :deactivate
    end
  end

  resources :courier_services, except: %i[show] do
    member do
      patch :activate
      patch :deactivate
    end
  end

  resources :brands, except: %i[show] do
    member do
      patch :activate
      patch :deactivate
    end
    collection do
      get :search
    end
  end

  resources :categories, except: %i[show] do
    member do
      patch :activate
      patch :deactivate
    end
    collection do
      get :search
    end
  end

  resources :distributors, except: %i[show] do
    member do
      patch :activate
      patch :deactivate
    end
    collection do
      get :search
    end
  end

  resources :products do
    member do
      patch :activate
      patch :deactivate
    end
    collection do
      get :search

      get :import
      post :create_import

      get :download_import_template

      get :export
      post :create_export
    end
  end

  resources :invoices do
    member do
      patch :post
      patch :mark_as_paid
    end
    collection do
      get :search
    end
  end
end
