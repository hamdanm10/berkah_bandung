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
end
