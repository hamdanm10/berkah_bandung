namespace :super_admin do
  resource :dashboard, only: %i[show]

  resources :notifications, only: %i[index]

  resource :account_setting, only: %i[edit update] do
    member do
      get :change_password
      patch :change_password
    end
  end

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
  end

  resources :categories, except: %i[show] do
    member do
      patch :activate
      patch :deactivate
    end
  end

  resources :distributors do
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
      get :import
      post :create_import

      get :download_import_template

      get :export
      post :create_export
    end
  end

  resources :merchant_orders, only: %i[index] do
    resources :order_batches, except: %i[show] do
      resources :orders do
        collection do
          get :duplicate_new
          post :duplicate_create
          get :print
        end
      end
    end
  end

  resources :delivered_orders, except: %i[destroy edit update] do
    member do
      patch :undo
    end
  end

  resources :paid_orders, except: %i[destroy edit update] do
    member do
      patch :undo
    end
  end

  resources :cancelled_orders, except: %i[destroy edit update] do
    member do
      patch :undo
    end
  end

  resources :returned_orders, except: %i[destroy edit update] do
    member do
      patch :undo
    end
    collection do
      post :scan_order
    end
  end

  resources :all_orders, only: %i[index show]

  resources :restock_invoices do
    member do
      patch :post
      patch :mark_as_paid
    end
    collection do
      get :search
    end
  end
end
