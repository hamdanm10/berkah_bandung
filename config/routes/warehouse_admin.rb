# frozen_string_literal: true

namespace :warehouse_admin do
  resource :dashboard, only: %i[show]

  resource :account_setting, only: %i[edit update] do
    member do
      get :change_password
      patch :change_password
    end
  end

  resources :restock_invoices

  resources :distributors do
    member do
      patch :activate
      patch :deactivate
    end
  end

  resources :products do
    resources :stock_adjustments, except: %i[destroy]
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
end
