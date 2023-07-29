Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"


  resources :admin, controller: 'admin/dashboard', only: [:index]

  # Route for Merchants under Admin
  namespace :admin, as: 'admin_merchants' do
    resources :merchants, only: [:index]
  end

  namespace :admin do
    resources :merchants, only: [:show, :edit, :update]
  end



# Merchant stuff


  
  resources :merchants, only: [:show] do
    resources :dashboard, only: [:index], controller: 'merchants/dashboard'
  end


  resources :merchants, only: [:show] do
    resources :invoices, only: [:index, :show], controller: "merchants/invoices"
  end

end

