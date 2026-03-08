namespace :order_admin do
  resource :dashboard, only: %i[show]

  resource :account_setting, only: %i[edit update] do
    member do
      get :change_password
      patch :change_password
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

  resources :all_orders, only: %i[index show]
  resources :courier_services, only: %i[index]
  resources :products, only: %i[index]
end
