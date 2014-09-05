FacebookActivity::Application.routes.draw do
  root to: 'index#index'

  get "users/get_my_location"

  # auth routes
  match '/login', to: 'sessions#new', as: 'login', via: [:get]
  match '/auth/:provider/callback', to: 'sessions#create', as: 'auth_callback', via: [:get, :post]
  match '/auth/failure', to: 'sessions#failure', as: 'auth_failure', via: [:get, :post]
  match '/auth/destroy', to: 'sessions#destroy', as: 'sign_out', via: :delete
end
