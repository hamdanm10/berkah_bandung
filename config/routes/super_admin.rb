namespace :super_admin do
  resource :dashboard, only: %i[show]
end
