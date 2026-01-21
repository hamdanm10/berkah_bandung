namespace :super_admin do
  resource :dashboard, only: %i[show]
  resources :invitations, except: %i[destroy]
  resources :users, only: %i[index show]
end
