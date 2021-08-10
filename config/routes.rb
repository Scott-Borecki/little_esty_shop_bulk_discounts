Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'admin/dashboard#index'

  resources :merchant, only: :show do
    resources :bulk_discounts
    resources :dashboard, only: :index
    resources :items, except: :destroy
    resources :item_status, only: :update
    resources :invoice_items, only: :update
    resources :invoices, only: [:index, :show]
  end

  namespace :admin do
    resources :dashboard, only: :index
    resources :merchants, except: :destroy
    resources :merchant_status, only: :update
    resources :invoices, except: [:destroy, :new]
  end
end
