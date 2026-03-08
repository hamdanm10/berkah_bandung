namespace :dispatch_admin do
  resource :dashboard, only: %i[show]

  resource :account_setting, only: %i[edit update] do
    member do
      get :change_password
      patch :change_password
    end
  end
end
